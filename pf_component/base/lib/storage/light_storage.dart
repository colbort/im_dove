import 'dart:async';
import 'dart:typed_data';
import 'package:base/log/log.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';

final lightModel = _LocalStorage();

/// 基于mmkv的一些简单键值对
class _LocalStorage {
  _LocalStorage();

  MmkvFlutter _mmkvCommon;
  Future<void> init() async {
    if (null == _mmkvCommon) _mmkvCommon = await MmkvFlutter.getInstance();
  }

  Future<bool> setString(String key, String value) {
    return _mmkvCommon.setString(key, value);
  }

  Future<String> getString(String key) {
    return _mmkvCommon.getString(key);
  }

  Future<void> setValue<T>(String key, T value) async {
    assert(_mmkvCommon != null, 'call ls.init() in start...');
    if (T == int) {
      await _mmkvCommon.setInt(key, value as int);
    } else if (T == bool) {
      await _mmkvCommon.setBool(key, value as bool);
    } else if (T == String) {
      l.d('setValue<String>: $key, $value', saveFile: true);
      await _mmkvCommon.setString(key, value as String);
    } else if (T == double) {
      await _mmkvCommon.setDouble(key, value as double);
    } else {
      assert(false, 'unknow type');
    }
  }

  Future<T> getValue<T>(String key) async {
    return Future<T>.value(await _getValueWithDefault<T>(key));
  }

  Future<dynamic> _getValueWithDefault<T>(String key) {
    assert(_mmkvCommon != null);
    if (T == int) {
      return _mmkvCommon.getInt(key);
    } else if (T == bool) {
      return _mmkvCommon.getBool(key);
    } else if (T == String) {
      return _mmkvCommon.getString(key);
    } else if (T == double) {
      return _mmkvCommon.getDouble(key);
    }
    assert(false, 'unkown type');
    return Future.value(null);
  }
}
