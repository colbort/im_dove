import 'dart:async';
import 'package:app/cfg.dart';
import 'package:dio/dio.dart';
import 'package:app/utils/logger.dart';

final _dev = cfg.isDev;

/// 选线地址
final _stat = "/api/srv/stat";

final _api = "/api";

final _timeout = 5 * 1000;

final hosts = _SelectLine();

typedef Future<String> Func();

class _SelectLine {
  /// 当前域名
  var _fastest = '';
  var _dio = Dio(BaseOptions(connectTimeout: _timeout));
  Func select;
  _SelectLine() {
    select = _dev ? _selectDev : _select;
  }

  Future<String> _selectDev() async {
    return _fastest = cfg.hosts[0] + _api;
  }

  /// 并发选线
  /// 返回第一个成功的线路
  /// 错误的时候
  Future<String> _select() async {
    // print(Address.URL_LIST.toString());
    var hosts = cfg.hosts;
    var cnt = hosts.length;
    var cpl = Completer<String>();
    for (var url in hosts) {
      log.i('[LINE] 当前测试url:$url');

      _dio.get(url + _stat).then((resp) {
        log.i('[LINE] 当前测试url完毕:$url');
        if (resp != null && resp.statusCode == 200) {
          log.i('[LINE] 当前测试url完毕 正确的返回:$url');
          _close();
          _fastest = url + _api;
          return cpl.complete(url);
        } else {
          throw DioError();
        }
      }).catchError((e) {
        // log.e('[LINE] 当前测试url完毕 错误的返回:$url ${e.error}');
        --cnt;

        if (cnt <= 0) {
          log.w('[LINE] 当前测试url完毕 全部错误');
          // _close();
          return cpl.complete('');
        }
      });
    }
    return cpl.future;
  }

  String get host => _fastest;

  checkSelect() {
    return false;
  }

  checkSelectSucc() {
    return _fastest.isEmpty;
  }

  _close() {
    if (_dio == null) return;
    _dio.close(force: true);
    _dio = null;
    log.i('line class auto closed');
  }
}
