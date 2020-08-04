import 'package:app/event/event.dart';
import 'package:app/net/routers.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/native.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

/// 响应拦截器
class HttpRespInterceptor extends InterceptorsWrapper {
  static const String TAG = "HttpRespInterceptor";
  final Dio _dio;
  HttpRespInterceptor(this._dio);
  @override
  Future onResponse(Response resp) async {
    if (null == resp) {
      var msg = "None response received!!!";
      l.e(TAG, "onResponse()...$msg");
      return Future.error(msg);
    }
    if (resp.data is DioError) {
      var msg = "DioError:${resp.data}";
      l.e(TAG, "onResponse()... $msg");
      return Future.error(msg);
    }
    _showTipsIfNeed(resp.data);
    switch (resp.statusCode) {
      case 200:
        return resp;
      case 302:
        l.i(TAG, 'need relogin: $url');
        await login();
        // return BaseRespBean(302);
        // return null;
        return Future.error("resp code is 302,need relogin: $url");
      case 301:
        l.i(TAG, 'need relogin: $url');
        //这里要判断下是否已经到主界面了，如果到主界面了，应该要调起手机登录界面
        if (mainPageInited) {
          reLoginEventBus.fire(null);
        } else {
          await login();
        }
        // return BaseRespBean(301);
        // return null;
        return Future.error("resp code is 301,need relogin: $url");
      case 400:
        l.i(TAG, '业务层错误 ${resp.data['msg'].toString()}');
        //这里要判断下如果服务端返回的为no token的错误，需要调用游客登录重新拉取下token
        if (resp.data['code'] == 1000) {
          var token = await getToken();
          if (token == null || token.isEmpty) {
            await login();
          }
        }
        // return BaseRespBean(resp.data['code'], data: resp?.data);
        // return resp;
        // return null;
        return Future.error('业务层错误 ${resp.data['msg'].toString()} url:$url');
      case 405:
        l.i(TAG, 'request method error , url: $url');
        // return BaseRespBean(405);
        // return null;
        return Future.error('resp code 405 ,request method error , url: $url');
      case 413:
        l.i(TAG, 'no premision, url: $url');
        // return BaseRespBean(413);
        // return null;
        return Future.error('resp code 413 ,no premision, url: $url');
      default:
        l.w(TAG, 'statusCode invalied : ${resp.statusCode}');
        // return BaseRespBean(0);
        // return null;
        return Future.error('unknow resp code');
    }
  }

  /// 显示弹窗
  _showTipsIfNeed(data) {
    if (data == null) return;
    var bMap = data is Map;
    if (!bMap) return;
    if (!data.containsKey("tip")) return;
    var tipStr = data["tip"] as String;
    if (TextUtil.isEmpty(tipStr)) return;
    showToast(tipStr);
  }

  /// 游客登陆
  Future<bool> login() async {
    // await delToken();

    if (!NetManager.isInited) {
      l.w(TAG, "[NET] not init yet");
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

    var resp = await _dio.request(Routers.USER_TRAVELER, data: args);
    l.i(TAG, 'rtn:' + resp.toString());
    if (resp.statusCode != 200) return false;

    setToken(resp.data['token']);
    return true;
  }
}
