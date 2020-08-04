import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:app/loc_server/req_parse.dart';
import 'package:app/loc_server/vedio_cache.dart';
import 'package:app/loc_server/vedio_data.dart';
import 'package:app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'video_queue.dart';

final baseOptions = BaseOptions(
  method: "GET",
  //连接服务器超时时间，单位是毫秒.
  connectTimeout: 10000,
  //响应流上前后两次接受到数据的间隔，单位为毫秒。
  receiveTimeout: 30000,
  //Http请求头.
  headers: {"user-agent": "dio", "api": "1.0.0"},
  //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
  contentType: ContentType.binary.toString(),
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.bytes,
);

final options = Options(
  method: "GET",
  //连接服务器超时时间，单位是毫秒.
  sendTimeout: 10000,
  //响应流上前后两次接受到数据的间隔，单位为毫秒。
  receiveTimeout: 30000,
  //Http请求头.
  headers: {"user-agent": "dio", "api": "1.0.0"},
  //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
  contentType: ContentType.binary.toString(),
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.bytes,
);

Dio _dio = Dio(baseOptions);
List<CancelToken> _cancleTokenList = List<CancelToken>();
//是否还缓存状态
bool _isCaching = false;
bool get isCaching => _isCaching;

Future<bool> cacheVideoElement(VideoElement element) async {
  if (element.m3u8Url == null || element.m3u8Url.isEmpty) {
    return false;
  }

  if (element.isCaching) {
    log.i("该片段正在缓存:" + element.videoId.toString());
    return false;
  }

  element.isCaching = true;
  _isCaching = true;
  String sUri = m3u8Remote2LocalUri(element.m3u8Url);
  String sMd5 = sUri.substring(1, sUri.indexOf('/', 1));
  //先缓存m3u8文件
  if (!element.m3u8Cached) {
    ReqType reqType = ReqType.m3u8;
    String relativePath = getRelativePath(reqType, sUri, sMd5);
    FileInfo fileInfo = await getCache(relativePath);
    if (fileInfo == null) {
      var rlt = await _cacheM3u8(element, sMd5, relativePath);
      if (!rlt) {
        element.isCaching = false;
        _isCaching = false;
        return false;
      }
    } else {
      element.m3u8Cached = true;
      var fileData = await fileInfo.file.readAsBytes();
      analysisM3u8Info(sMd5, fileData.toList());
      if (m3u8InfoMap[sMd5].keyUrl != null &&
          m3u8InfoMap[sMd5].keyUrl.isNotEmpty) {
        element.keyUrl = m3u8InfoMap[sMd5].keyUrl;
      }

      element.tsUrl.clear();
      element.tsCache.clear();
      for (int i = 0; i < tsCacheWindow; i++) {
        element.tsUrl.add('/' + sMd5 + '/' + m3u8InfoMap[sMd5].tsList[i]);
        element.tsCache.add(false);
      }
    }
  }

  // //key缓存
  // if (!element.keyCached) {
  //   if (element.keyUrl == null || element.keyUrl.isEmpty) {
  //     element.keyCached = true;
  //   } else {
  //     ReqType reqType = ReqType.key;
  //     sUri = element.keyUrl;
  //     String relativePath = getRelativePath(reqType, sUri, sMd5);
  //     FileInfo fileInfo = await getCache(relativePath);
  //     if (fileInfo == null) {
  //       var rlt = await _cacheKey(element, sMd5, relativePath);
  //       if (!rlt) {
  //         _isCaching = false;
  //         return false;
  //       }
  //     } else {
  //       element.keyCached = true;
  //     }
  //   }
  // }

  //ts缓存
  for (int i = 0; i < tsCacheWindow; i++) {
    if (element.tsCache[i]) {
      continue;
    } else {
      ReqType reqType = ReqType.ts;
      sUri = element.tsUrl[i];
      String relativePath = getRelativePath(reqType, sUri, sMd5);
      FileInfo fileInfo = await getCache(relativePath);
      if (fileInfo == null) {
        var rlt = await _cacheTS(sUri, sMd5, relativePath);
        if (!rlt) {
          element.isCaching = false;
          _isCaching = false;
          return false;
        } else {
          element.tsCache[i] = true;
          continue;
        }
      } else {
        element.tsCache[i] = true;
        continue;
      }
    }
  }

  element.isCaching = false;
  _isCaching = false;
  return true;
}

void cancelCurCacheTask() {
  _cancleTokenList.forEach((_token) {
    _token?.cancel('cancel cache');
  });

  _cancleTokenList.clear();
}

Future<bool> _cacheM3u8(
    VideoElement element, String sMd5, String relativePath) async {
  var _cancelToken = CancelToken();
  _cancleTokenList.add(_cancelToken);
  try {
    log.i('cache模块 m3u8 url:' + element.m3u8Url);
    var response = await _dio.get(
      element.m3u8Url,
      cancelToken: _cancelToken,
      options: options,
    );
    _cancleTokenList.remove(_cancelToken);
    analysisM3u8Info(sMd5, response.data);
    if (m3u8InfoMap[sMd5].keyUrl != null &&
        m3u8InfoMap[sMd5].keyUrl.isNotEmpty) {
      element.keyUrl = m3u8InfoMap[sMd5].keyUrl;
    }

    element.tsUrl.clear();
    element.tsCache.clear();
    for (int i = 0; i < tsCacheWindow; i++) {
      element.tsUrl.add('/' + sMd5 + '/' + m3u8InfoMap[sMd5].tsList[i]);
      element.tsCache.add(false);
    }

    log.i('cache模块 m3u8相对路径relativePath:' + relativePath);
    await VedioCacheManager().putFile(
        relativePath, Uint8List.fromList(response.data),
        maxAge: Duration(days: 1000));
    element.m3u8Cached = true;
    return true;
    //m3u8 分析, 得到key地址，ts片段地址
  } on DioError catch (e) {
    _cancleTokenList.remove(_cancelToken);
    log.i('downloadFile error---------$e' + " relativePath:" + relativePath);
    return false;
  }
}

// Future<bool> _cacheKey(
//     VideoElement element, String sMd5, String relativePath) async {
//   var _cancelToken = CancelToken();
//   _cancleTokenList.add(_cancelToken);

//   try {
//     var keyUrl = getRemoteUrl(ReqType.key, element.keyUrl, sMd5);
//     log.i('cache模块 keyUrl:' + keyUrl);
//     var response = await _dio.get(
//       keyUrl,
//       cancelToken: _cancelToken,
//       options: options,
//     );
//     _cancleTokenList.remove(_cancelToken);
//     log.i('cache模块 key相对路径relativePath:' + relativePath);
//     await VedioCacheManager().putFile(
//         relativePath, Uint8List.fromList(response.data),
//         maxAge: Duration(days: 1000));
//     element.keyCached = true;
//     return true;
//     //m3u8 分析, 得到key地址，ts片段地址
//   } on DioError catch (e) {
//     _cancleTokenList.remove(_cancelToken);
//     log.w('downloadFile error---------$e' + "  relativePath:" + relativePath);
//     return false;
//   }
// }

Future<bool> _cacheTS(String sUri, String sMd5, String relativePath) async {
  var _cancelToken = CancelToken();
  _cancleTokenList.add(_cancelToken);

  try {
    var tsUrl = getRemoteUrl(ReqType.ts, sUri, sMd5);
    log.i('cache模块 tsUrl:' + tsUrl);
    var response = await _dio.get(
      tsUrl,
      cancelToken: _cancelToken,
      options: options,
    );
    _cancleTokenList.remove(_cancelToken);
    log.i('cache模块 ts相对路径relativePath:' + relativePath);
    await VedioCacheManager().putFile(
        relativePath, Uint8List.fromList(response.data),
        maxAge: Duration(days: 1000));
    return true;
    //m3u8 分析, 得到key地址，ts片段地址
  } on DioError catch (e) {
    _cancleTokenList.remove(_cancelToken);
    log.i('downloadFile error---------$e' + " relativePath:" + relativePath);
    return false;
  }
}
