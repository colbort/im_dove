import 'package:dio/dio.dart';
import 'dart:async';

final _timeout = 3 * 1000;
const PASS_ENABLE = 'pass_key';

/// 提审host地址
final _statA = "https://api.whuzxw.com/api/pass/conf";
final _pkgtype = "paofu_tfvideoplayer_2.3.2";
var _dio = Dio(BaseOptions(connectTimeout: _timeout));

///判断苹果审核网络
final url = "http://ip-api.com/json/?lang=zh-CN";

final storeHost = _CheckPass();

enum PassEnable {
  //需要提审
  need,
  //不需要提审
  noneed,
}

Future<dynamic> getNetEnv() async {
  try {
    var responseApp = await _dio.get(url);
    if (responseApp.statusCode == 200) {
      print(responseApp);
      if ("Apple Inc." == responseApp.data['isp']) {
        //苹果审核的网络特征
        return 'Apple Inc.';
      }
      return "有网络";
    } else {
      return "请求错误";
    }
  } catch (e) {
    return "无网络";
  }
}

Future<dynamic> _getPassPkgType() async {
  try {
    var response = await _dio.get(_statA, queryParameters: {"pkg": _pkgtype});
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  } catch (e) {
    _getPassPkgType();
  }
}

class _CheckPass {
  //检测pass
  Future<String> needOnline() async {
    // if (PassEnable.noneed.toString() == await getPassEnable()) {
    //   return "2";
    // }
    //获取苹果审核网络字段
    var value = await getNetEnv();
    if (value == 'Apple Inc.') {
      return '1';
    } else {
      Response response = await _getPassPkgType();
      if (response != null) {
        var passEnable = response.data["passEnable"];
        if (passEnable == 1) {
          //存储需要提审状态,返回host
          // await ls.save(PASS_ENABLE, PassEnable.need.toString());
          //需要审核
          return "1";
        } else {
          // await ls.save(PASS_ENABLE, PassEnable.noneed.toString());
          //不需要审核
          return "2";
        }
      } else {
        return "1";
      }
    }
  }

  // ///获取提审状态
  // getPassEnable() async {
  //   String passTpye = await ls.get(PASS_ENABLE);
  //   return passTpye.toString();
  // }
}
