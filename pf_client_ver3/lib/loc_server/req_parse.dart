import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'vedio_data.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'vedio_cache.dart';
import 'package:app/utils/logger.dart';
import 'download.dart';

enum ReqType { m3u8, key, ts }
enum DownloadState { downling, error, finished }

Future m3u8ReqParse(HttpRequest req, String sUri, String dir) async {
  String sMd5 = sUri.substring(1, sUri.indexOf('/', 1));
  ReqType reqType = ReqType.m3u8;
  var relativePath = getRelativePath(reqType, sUri, sMd5);
  //读取缓存状态
  FileInfo fileInfo = await getCache(relativePath);
  if (fileInfo == null) {
    String remoteUrl = getRemoteUrl(reqType, sUri, sMd5);
    CancelToken cancelToken = CancelToken();
    cancleTokenList.add(cancelToken);
    //下载以及缓存
    try {
      log.i('remoteUrl:' + remoteUrl);
      await getFile(remoteUrl, (received, total, data) {}, (data) async {
        cancleTokenList.remove(cancelToken);
        log.i('相对路径relativePath:' + relativePath);
        await VedioCacheManager().putFile(
            relativePath, Uint8List.fromList(data),
            maxAge: Duration(days: 1000));

        List<int> m3u8 = await analysisM3u8Info(sMd5, data);

        req.response.headers.contentType =
            ContentType("application", "octet-stream", charset: "utf-8");
        try {
          memoryCache(sUri, m3u8);
          req.response.add(m3u8);
          // await req.response.flush();
          await req.response.close();
          return;
        } catch (e) {
          log.w("add err: $e");
          req.response.statusCode = HttpStatus.notFound;
          await req.response.close();
          return;
        }
      }, (e) async {
        cancleTokenList.remove(cancelToken);
        req.response.statusCode = HttpStatus.notFound;
        await req.response.close();
        log.w("Couldn't download file: $e");
        return;
      }, cancelToken);
    } catch (e) {
      cancleTokenList.remove(cancelToken);
      log.w("err: $e");
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
      return;
    }
    //req.response.statusCode = HttpStatus.notFound;
  } else {
    log.i("有缓存可以用");
    log.i("Serving ${fileInfo.file.path}.");
    var fileData = await fileInfo.file.readAsBytes();
    //m3u8解析
    List<int> m3u8 = await analysisM3u8Info(sMd5, fileData);
    req.response.headers.contentType =
        ContentType("application", "octet-stream", charset: "utf-8");
    memoryCache(sUri, m3u8);
    req.response.add(m3u8);
    // await req.response.flush();
    await req.response.close();
  }
}

Future keyAndTsReqParse(
    HttpRequest req, String sUri, String dir, ReqType reqType) async {
  String sMd5 = sUri.substring(1, sUri.indexOf('/', 1));
  var relativePath = getRelativePath(reqType, sUri, sMd5);
  //读取缓存状态
  FileInfo fileInfo = await getCache(relativePath);
  if (fileInfo == null) {
    String remoteUrl = getRemoteUrl(reqType, sUri, sMd5);
    StreamController<List<int>> streamController = StreamController();
    DownloadState downloadState = DownloadState.downling;
    CancelToken cancelToken = CancelToken();
    cancleTokenList.add(cancelToken);
    //下载以及缓存
    try {
      log.i('remoteUrl:' + remoteUrl);
      getFile(remoteUrl, (received, total, data) {
        streamController.add(data);
      }, (data) async {
        var file = await VedioCacheManager().putFile(
            relativePath, Uint8List.fromList(data),
            maxAge: Duration(days: 1000));
        log.i("下载成功:" + file.path.toString());
        downloadState = DownloadState.finished;
        streamController.close();
      }, (e) {
        downloadState = DownloadState.error;
        log.w("xxx Couldn't download file: $e");
        streamController.close();
      }, cancelToken);

      req.response.headers.contentType =
          ContentType("application", "octet-stream", charset: "utf-8");
      await req.response.addStream(streamController.stream);
      log.i('addStream end');

      //这里要判断下是否播放器已经取消了连接，如果播放器取消了连接，最好取消掉当前下载的连接

      cancleTokenList.remove(cancelToken);
      if (downloadState == DownloadState.finished) {
        log.i('相对路径relativePath:' + relativePath);
      } else if (downloadState == DownloadState.downling) {
        log.w("cancal DownloadState.downling");
        //req.response.statusCode = HttpStatus.notFound;
        cancelDownload(cancelToken);
      }
      await req.response.close();
      return;
    } catch (e) {
      cancleTokenList.remove(cancelToken);
      downloadState = DownloadState.error;
      log.w("Couldn't download file: $e");
      //req.response.statusCode = HttpStatus.notFound;
      streamController.close();
      await req.response.close();
      return;
    }

    //req.response.statusCode = HttpStatus.notFound;
  } else {
    log.i("有缓存可以用");

    req.response.headers.contentType =
        ContentType("application", "octet-stream", charset: "utf-8");
    try {
      var data = await fileInfo.file.readAsBytes();
      memoryCache(sUri, data);
      req.response.add(data);
      await req.response.close();
      return;
    } catch (e) {
      log.w("yyy Couldn't read file: $e" + " file:" + fileInfo.file.path);
      await removeCache(relativePath);
      req.response.statusCode = HttpStatus.notFound;
      await req.response.close();
      return;
    }
  }
}

ReqType analysisReqType(String uri) {
  if (uri.endsWith('.m3u8')) {
    return ReqType.m3u8;
  } else if (uri.endsWith('.ts')) {
    return ReqType.ts;
  } else {
    return ReqType.key;
  }
}

String getRelativePath(ReqType type, String uri, String curMd5) {
  if (type == ReqType.key) {
    // return curMd5 + '/deckey';
    //这里的key去掉md5，只判断下载路由
    return uri.substring(uri.indexOf('/', 1) + 1);
  } else {
    return uri.substring(1);
  }
}

String getRemoteUrl(ReqType type, String uri, String curMd5) {
  if (type == ReqType.m3u8) {
    return completeM3u8Url[curMd5];
  } else if (type == ReqType.ts) {
    var tsName = uri.substring(uri.lastIndexOf('/') + 1);
    // log.i("tsName:" + tsName);
    // log.i("m3u8Name:" + m3u8Name);
    var m3u8Info = m3u8InfoMap[curMd5];
    if (m3u8Info.tsDoaminUr == null || m3u8Info.tsDoaminUr.isEmpty) {
      return completeM3u8Url[curMd5].replaceFirst(m3u8Name[curMd5], tsName);
    } else {
      return m3u8Info.tsDoaminUr + '/' + tsName;
    }
  } else {
    uri = uri.replaceFirst("/" + curMd5, "");
    return m3u8DomainUrl[curMd5] + uri;
  }
}

Future<List<int>> analysisM3u8Info(String sMd5, List<int> m3u8) async {
  if (m3u8InfoMap[sMd5] == null) {
    int tmpSum = 0;
    m3u8InfoMap[sMd5] = M3u8Info();
    String source = String.fromCharCodes(m3u8);
    //log.i('source:' + source);
    List<String> arr = source.split('\n');
    //处理下key,带上md5, --  "#EXT-X-KEY:METHOD=AES-128,URI="/api/file/enkey"" to #EXT-X-KEY:METHOD=AES-128,URI="$sMd5/api/file/enkey"
    List<String> key = arr.where((i) => i.indexOf('#EXT-X-KEY') >= 0).toList();
    if (key.length > 0) {
      var sKey = key[0];
      var gapIdx = sKey.indexOf('URI=');
      var s1 = sKey.substring(0, gapIdx + 5);
      var s2 = "/" + sMd5 + sKey.substring(gapIdx + 5);
      source = source.replaceFirst(sKey, s1 + s2);
      m3u8InfoMap[sMd5].keyUrl = s2;
    }
    //log.i('arr:' + arr.length.toString());
    m3u8InfoMap[sMd5].tsList = arr.where((i) => i.indexOf('.ts') >= 0).map((v) {
      var tmpIdx = v.lastIndexOf('/');
      if (tmpIdx >= 0) {
        if (m3u8InfoMap[sMd5].tsDoaminUr == null ||
            m3u8InfoMap[sMd5].tsDoaminUr.isEmpty) {
          m3u8InfoMap[sMd5].tsDoaminUr = v.substring(0, tmpIdx);
        }
        return v.substring(tmpIdx + 1);
      } else {
        return v;
      }
    }).toList();
    m3u8InfoMap[sMd5].timeList =
        arr.where((i) => i.indexOf('#EXTINF:') >= 0).map((v) {
      v = v.substring(v.indexOf(':') + 1, v.length - 1);
      tmpSum += (double.parse(v) * 1000).toInt();
      return tmpSum;
    }).toList();

    // log.i(
    //     'm3u8InfoMap[sMd5].tsList:' + m3u8InfoMap[sMd5].tsList.toString());
    // log.i('m3u8InfoMap[sMd5].timeList:' +
    //     m3u8InfoMap[sMd5].timeList.toString());
    if (m3u8InfoMap[sMd5].tsDoaminUr == null ||
        m3u8InfoMap[sMd5].tsDoaminUr.isEmpty) {
      m3u8InfoMap[sMd5].m3u8 = source.codeUnits;
    } else {
      m3u8InfoMap[sMd5].m3u8 = Uint8List.fromList(
          source.replaceAll(m3u8InfoMap[sMd5].tsDoaminUr + '/', '').codeUnits);
    }
    return m3u8InfoMap[sMd5].m3u8;
  } else {
    return m3u8InfoMap[sMd5].m3u8;
  }
}
