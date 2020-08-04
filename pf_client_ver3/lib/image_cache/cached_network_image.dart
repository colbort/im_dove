export 'package:cached_network_image/src/cached_image_widget.dart';
export 'package:cached_network_image/src/cached_network_image_provider.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:app/image_cache/decrypt_image.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImgCacheMgr extends BaseCacheManager {
  static const key = "imgCache";

  static ImgCacheMgr _instance;

  factory ImgCacheMgr() {
    if (_instance == null) {
      _instance = ImgCacheMgr._();
    }
    return _instance;
  }

  ImgCacheMgr._()
      : super(
          key,
          maxAgeCacheObject: Duration(days: 365),
          maxNrOfCacheObjects: 10000,
          fileFetcher: _customHttpGetter,
        );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url,
      {Map<String, String> headers}) async {
    Response response = await get(url, headers: headers);
    Response processedResponse = Response.bytes(
        decryptImage(response.bodyBytes), response.statusCode,
        headers: {'cache-control': 'max-age=31104000'});
    // processedResponse.headers['cache-control'] = 'max-age=31104000';
    return HttpFileFetcherResponse(processedResponse);
  }

  /// 获取图片缓存大小,返回单位为Byte
  Future<double> getCacheRomSize() async {
    var path = await getFilePath();
    Directory dir = Directory(path);
    double value = await _getTotalSizeOfFilesInDir(dir);
    print("stat: " + value.toString());
    return value;
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }
}
