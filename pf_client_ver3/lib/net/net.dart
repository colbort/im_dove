import 'dart:async';
import 'dart:io';

import 'package:app/net/routers.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/native.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/version.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:app/event/event.dart';
import 'http_interceptor.dart';
export 'code.dart';
export 'routers.dart';

final timeout = 15 * 1000;

final net = _NetManager();

class RespData {
  int code;
  dynamic data;

  RespData(this.code, {this.data});

  msg() {
    // map[code]
    return '服务器开小差了~';
  }
}

///http请求
class _NetManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio;
  //final TokenInterceptors _tokenInterceptors = TokenInterceptors();
  var _inited = false;

  void init(String host) {
    _dio = Dio(BaseOptions(connectTimeout: timeout, baseUrl: host)); // 使用默认配置
    _dio.interceptors.add(HttpInterceptors(_dio));
    log.d('[NET] init ok, domain:$host');
    _inited = true;
  }

  bool get inited => _inited;

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

  /// request/response
  /// args : json formdata null
  /// method : post get
  /// params:get 方式参数
  Future<RespData> request(String route,
      {args, String method = 'post', params}) async {
    // method = method.trim().toLowerCase();
    // assert(method != 'post' && method != 'get');

    if (!inited) {
      log.w("[NET] not init yet");
      return null;
    }

    // var url = join(_base, route);
    var option = Options(method: method);
    var token = await getToken();
    l.d("test", "token:$token");
    option.headers["Authorization"] = token;
    option.headers["User-Agent"] = userAgent();

    option.validateStatus = (code) {
      return code <= 600;
    };

    Response resp;
    try {
      resp = await _dio.request(route,
          queryParameters: params, data: args, options: option);
    } on DioError catch (e) {
      log.e('request $e');
      return RespData(0);
    } catch (e) {
      log.e('request $e');
      return RespData(-1);
    }

    if (resp.data is DioError) {
      log.e('request ${resp.data}');
      return RespData(0);
    }
    showToast(resp.data);

    switch (resp.statusCode) {
      case 200:
        return RespData(200, data: resp?.data);
      //add new state for relogin
      case 302:
        log.i('need relogin: $url');
        await login();
        return RespData(302);
      case 301:
        log.i('need relogin: $url');
        //这里要判断下是否已经到主界面了，如果到主界面了，应该要调起手机登录界面
        if (mainPageInited) {
          reLoginEventBus.fire(null);
        } else {
          await login();
        }
        return RespData(301);
      case 400:
        log.i('业务层错误 ${resp.data['msg'].toString()}');
        //这里要判断下如果服务端返回的为no token的错误，需要调用游客登录重新拉取下token
        if (resp.data['code'] == 1000) {
          var token = await getToken();
          if (token == null || token.isEmpty) {
            await login();
          }
        }
        return RespData(resp.data['code'], data: resp?.data);
      case 405:
        log.i('request method error <$method>, url: $url');
        return RespData(405);
      case 413:
        log.i('no premision, url: $url');
        return RespData(413);
      default:
        log.w('statusCode invalied : ${resp.statusCode}');
        return RespData(0);
    }
  }

  /// 游客登陆
  Future<bool> login() async {
    // await delToken();

    if (!inited) {
      log.w("[NET] not init yet");
      return false;
    }

    var devId = await n.getUUID();
    var args = {'devId': devId, 'coat': 'Puff'};
    var content = await Clipboard.getData(Clipboard.kTextPlain);
    if (content?.text != null) {
      args['code'] = content.text.length >= 200
          ? content.text.substring(0, 199)
          : content.text;
    }
    // var data = jsonFrom(content?.text);
    // if (data != null) {
    //   if (data['c'] != null) {
    //     args['channelCode'] = data['c'];
    //   } else if (data['p'] != null) {
    //     args['inviteCode'] = data['p'];
    //   }
    // }

    var resp = await net.request(Routers.USER_TRAVELER, args: args);
    log.i('rtn:' + resp.toString());
    if (resp.code != 200) return false;

    setToken(resp.data['token']);
    return true;
  }

  /// 显示弹窗
  showToast(data) {
    if (data == null) return;
    var bMap = data is Map;
    if (!bMap) return;
    if (!data.containsKey("tip")) return;
    var tipStr = data["tip"] as String;
    if (tipStr == null || tipStr.isEmpty) return;
    showToast(tipStr);
  }
}
