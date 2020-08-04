import 'dart:convert';
import 'dart:typed_data';

import 'package:app/utils/logger.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

export 'keys.dart';

final _key = 'localStoreCache';
final _maxAge = Duration(days: 365 * 10);
final _maxNum = 50000;

final ls = _Storage();

class _CacheMgr extends BaseCacheManager {
  _CacheMgr()
      : super(_key, maxAgeCacheObject: _maxAge, maxNrOfCacheObjects: _maxNum);

  Future<String> getFilePath() async {
    var dir = await getTemporaryDirectory();
    return join(dir.path, _key);
  }
}

/// 本地存储
/// key 请使用 StorageKeys里的静态String
class _Storage {
  final _mgr = _CacheMgr();

  Future<bool> save(String key, String val) async {
    return await _mgr.putFile(key, Uint8List.fromList(utf8.encode(val)),
            maxAge: _maxAge, fileExtension: 'local') !=
        null;
  }

  Future<String> get(String key) async {
    var cache = await _mgr.getFileFromCache(key);
    if (cache == null) return null;

    //print(cacheFile.validTill.toIso8601String());
    if (cache.validTill.isBefore(DateTime.now())) return null;

    try {
      return await cache.file.readAsString();
    } catch (err) {
      log.e('Storage get<$key> err: $err');
      return null;
    }
  }

  Future<bool> remove(String key) async {
    return await _CacheMgr().removeFile(key) != null;
  }
}
