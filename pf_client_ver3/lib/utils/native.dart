import 'package:flutter/services.dart';
import 'dart:io';

final n = _Native();
final _uri = 'com.world/';

///CLASS:原生交互类
class _Native {
  ///MARK:方法调用
  var _methodChl = MethodChannel(_uri + 'method');

  // ///MARK:事件发送
  //  var EventChannel _eventChannel = const EventChannel(uri + 'event');

  ///MARK:消息传递
  // var _messageChl =
  //     BasicMessageChannel(_uri + 'message', StandardMessageCodec());

  ///FUNC:获取设备UUID
  Future<String> getUUID() async {
    return await _methodChl.invokeMethod('getUUID');
  }

  // ///FUNC:获取压缩之后的图片二进制流
  // Future<ByteData> compressImage(AssetImage image, double compresion,
  //     {double imageW, double imageH}) async {
  //   if (imageW != null && imageH != null) {
  //     var data = await _methodChl.invokeMethod('comperssImage', {
  //       "image": image,
  //       "imageW": imageW,
  //       "imageH": imageH,
  //       "compresion": compresion
  //     });
  //     return data;
  //   } else {
  //     var data = await _methodChl.invokeMethod(
  //         'comperssImage', {"image": image, "compresion": compresion});
  //     return data;
  //   }
  // }

  /// todo:截屏
  // Future<Uint8List> screenShot() async {
  //   var result = await methodChannel.invokeMethod("screenShot");
  //   if (result == null) {
  //     return null;
  //   }
  //   return result;
  // }

  /// todo:设置屏幕亮度
  Future<void> setSystemBrightness(double brightness) async {
    await _methodChl
        .invokeMethod("setSystemBrightness", {"brightness": brightness});
  }

  /// todo:获取屏幕亮度
  Future<double> getSystemBrightness() async {
    return await _methodChl.invokeMethod("getSystemBrightness");
  }

  /// todo:重置屏幕亮度
  Future<void> resetBrightness() async {
    await _methodChl.invokeMethod("resetBrightness");
  }

  /// todo:设置系统音量
  Future<void> setSystemVolume(int volume) async {
    await _methodChl.invokeMethod("setSystemVolume", {"volume": volume});
  }

  /// todo：获取系统音量
  Future<int> getSystemVolume() async {
    return _methodChl.invokeMethod("getSystemVolume");
  }

  /// todo:增加系统音量
  Future<int> systemVolumeUp() async {
    return _methodChl.invokeMethod("volumeUp");
  }

  /// todo:减小系统音量
  Future<int> systemVolumeDown() async {
    return _methodChl.invokeMethod("volumeDown");
  }

  Future<String> getVersionName() async {
    return _methodChl.invokeMethod("getVersionName");
  }

  Future<void> installApkFile(String filePath) async {
    if (Platform.isAndroid) {
      await _methodChl.invokeMethod(
          "installApkFile", <String, dynamic>{"filePath": filePath});
    }
  }

  /// 是否安装tf
  Future<bool> installTestFlight() async {
    var flag = await _methodChl.invokeMethod('installTestFlight');
    return flag;
  }
}
