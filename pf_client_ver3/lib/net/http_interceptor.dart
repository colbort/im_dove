import 'package:app/utils/logger.dart';
import 'package:app/utils/utils.dart';
import 'package:dio/dio.dart';

/// 网络结果拦截器
class HttpInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  HttpInterceptors(this._dio) {
    log.i(_dio.toString());
  }

  @override
  onRequest(RequestOptions options) async {
    log.d(
        '[NET] req path:<${options.uri.toString()}> options:<${options?.data.toString()}>');
    return Future.value(options);
  }

  @override
  onResponse(Response response) {
    log.d('[NET] resp: ${response?.toString()}');
    var token = response.headers.map['refresh-authorization']?.last;

    if (token != null) {
      setToken(token);
    }
    return Future.value(response);
  }

  @override
  onError(DioError err) async {
    log.w('[NET] err ${err.toString()} ${err.response?.toString()}');
    return Future.value(err);
  }
}
