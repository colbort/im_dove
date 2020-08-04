import 'package:app/storage/index.dart';
// import 'package:app/utils/logger.dart';

final passcode = _Passcode();

class _Passcode {
  String _code;

  /// get requested passcode
  /// [return] null 就是还没有await成功， ''就是没有设置密码
  String get code => _code;

  /// request passcode
  Future<String> request() async {
    _code = await ls.get(StorageKeys.PASSCODE) ?? '';
    return _code;
  }

  /// save passcode
  /// 如果code是空，就是取消密码
  Future<bool> save({String code = ''}) async {
    var ok = await ls.save(StorageKeys.PASSCODE, code ?? '');
    if (ok) _code = code;
    return ok;
  }
}
