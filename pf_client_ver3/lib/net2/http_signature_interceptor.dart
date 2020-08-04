import 'package:dio/dio.dart';

/// 验签拦截器，主要是做接口安全，加时间戳，加盐，加crc
class SignatureInterceptor extends InterceptorsWrapper {}
