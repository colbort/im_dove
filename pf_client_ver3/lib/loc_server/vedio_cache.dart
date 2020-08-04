import 'package:path_provider/path_provider.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;

class VedioCacheManager extends BaseCacheManager {
  static const key = "libVedioCacheManager";

  static VedioCacheManager _instance;

  factory VedioCacheManager() {
    if (_instance == null) {
      _instance = VedioCacheManager._();
    }
    return _instance;
  }

  VedioCacheManager._()
      : super(
          key,
          maxAgeCacheObject: Duration(days: 1000),
          maxNrOfCacheObjects: 1000,
        );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}

cacheInit() {
  VedioCacheManager();
}

Future<FileInfo> getCache(String relativePath) async {
  //先从内存里面读取
  var fileInfo = VedioCacheManager().getFileFromMemory(relativePath);
  //再从缓存中读取
  fileInfo =
      fileInfo ?? await VedioCacheManager().getFileFromCache(relativePath);

  return fileInfo;
}

removeCache(String relativePath) async {
  return VedioCacheManager().removeFile(relativePath);
}
