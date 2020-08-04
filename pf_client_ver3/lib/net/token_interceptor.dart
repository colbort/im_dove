import 'package:dio/dio.dart';
import 'package:app/storage/index.dart';

/// Token拦截器
class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  onRequest(RequestOptions options) async {
    //授权码
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
      }
    }
    options.headers["Authorization"] = _token;
    return options;
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;
    ls.remove(StorageKeys.TOKEN);
  }

  ///获取授权token
  getAuthorization() async {
    String token = await ls.get(StorageKeys.TOKEN);
    if (token == null) {
    } else {
      this._token = token;
      return token;
    }
  }
}
