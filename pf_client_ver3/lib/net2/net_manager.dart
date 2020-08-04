import 'package:app/net2/http_header_interceptor.dart';
import 'package:app/net2/http_log_interceptor.dart';
import 'package:app/net2/http_resp_interceptor.dart';
import 'package:dio/dio.dart';

import 'client_api.dart';

/// 连接超时15秒
const int CONNECT_TIME_OUT = 15 * 1000;

final netManager = NetManager();

class NetManager {
  Dio _dio; // Provide a dio instance
  static bool _inited = false;
  ClientApi client;
  init(String baseUrl) {
    _dio = Dio(BaseOptions(connectTimeout: CONNECT_TIME_OUT, baseUrl: baseUrl));
    _dio.interceptors.add(HttpLogInterceptor());
    _dio.interceptors.add(HttpRequestHeaderInterceptor());
    _dio.interceptors.add(HttpRespInterceptor(_dio));

    _inited = true;
    client = ClientApi(_dio);

    // StreamController sc;
    // var sub = sc.stream.listen((it) {});
    // sub.cancel();
  }

  static bool get isInited => _inited;
}
