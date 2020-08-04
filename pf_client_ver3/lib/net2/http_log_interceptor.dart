import 'package:app/utils/log.dart';
import 'package:dio/dio.dart';

/// 网络日志拦截器
class HttpLogInterceptor extends InterceptorsWrapper {
  static const String TAG = "http_log";
  HttpLogInterceptor();

  @override
  onRequest(RequestOptions options) async {
    l.d(TAG, '################# BEGIN REQUEST #####################\n');
    l.d(TAG, 'method:${options.method}  path:${options.uri.toString()}\n');
    l.d(TAG, 'param:${options?.data.toString()}\n');
    l.d(TAG, '################# END REQUEST #####################\n');
    return Future.value(options);
  }

  @override
  onResponse(Response response) {
    l.d(TAG, '################# BEGIN RESPONSE #####################\n');
    l.d(TAG, 'path:${response?.request?.uri}\n');
    l.d(TAG, 'begin resp: ${response?.toString()}\n');
    l.d(TAG, '################# END RESPONSE #####################\n');
    return Future.value(response);
  }

  @override
  onError(DioError err) async {
    l.w(TAG, 'request  err ${err.toString()} ${err.response?.toString()}');
    return Future.value(err);
  }
}
