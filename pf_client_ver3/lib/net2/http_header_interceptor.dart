import 'dart:io';

import 'package:app/utils/log.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/version.dart';
import 'package:dio/dio.dart';

/// 请求header拦截器
/// 主要是为每个请求添加header
class HttpRequestHeaderInterceptor extends InterceptorsWrapper {
  HttpRequestHeaderInterceptor();

  @override
  onRequest(RequestOptions options) async {
    var token = await getToken();
    options.headers["Authorization"] = token;
    l.d('http_log', 'token:$token');
    options.headers["User-Agent"] = userAgent();
    // options.headers["Content-Type"] = "application/x-www-form-urlencoded";
    // options.headers["Accept"] = "application/json;charset=UTF-8";
    options.headers["app_version"] = version.versionLocal;
    options.headers["api_version"] = "1.0.0";
    options.headers["device"] = Platform.operatingSystem;
    options.validateStatus = (code) {
      return code <= 600;
    };
    return Future.value(options);
  }

  String userAgent() {
    var ver = version.versionLocal;
    // 总是添加Auth header， 理论上只有首次连接的时候可以不用。
    var iosAgent = 'Mozilla/5.0 (iPhone; ' +
        Platform.operatingSystemVersion +
        '); version:$ver';
    var androidAgent = 'Mozilla/5.0 (Android; ' +
        Platform.operatingSystemVersion +
        '); version:$ver';

    return Platform.operatingSystem == "ios" ? iosAgent : androidAgent;
  }

  @override
  onResponse(Response response) {
    var token = response.headers.map['refresh-authorization']?.last;
    if (token != null) {
      setToken(token);
    }
    return Future.value(response);
  }
}
