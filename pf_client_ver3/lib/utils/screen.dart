import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

import 'logger.dart';

final s = _ScreenUitl();

class _ScreenUitl {
//********************************适配  start**************************************************** */
  ///与360设计尺寸宽比
  var _screenWRatio = 1.0;
  var _screenHRatio = 1.0;
//手机实际宽度
  var _screenWidth = 0.0;
//手机实际高度
  var _screenHeight = 0.0;

// //实际密度
//   var _screenDensity = 0.0;
//   var _statusBarHeight = 0.0;
// //bottombar高度
//   var _bottomBarHeight = 0.0;
// //appbar高度
//   var _appBarHeight = 0.0;

//设计稿尺寸宽
//设计稿尺寸高
  var sreenDefaultW = 360.0;
  var sreenDefaultH = 780.0;

  MediaQueryData _mediaQueryData;

  init() {
    var data = MediaQueryData.fromWindow(ui.window);
    if (_mediaQueryData != data) {
      _mediaQueryData = data;
      _screenWidth = data.size.width;
      _screenHeight = data.size.height;
      // _screenDensity = data.devicePixelRatio;
      // _statusBarHeight = data.padding.top;
      // _bottomBarHeight = data.padding.bottom;
      // _appBarHeight = kToolbarHeight;
      _screenWRatio = _screenWidth / sreenDefaultW;
      _screenHRatio = _screenHeight / sreenDefaultH;
      log.i(
          '[SCREEN] 设计尺寸:[$sreenDefaultW,$sreenDefaultH] 实际尺寸:[$_screenWidth,$_screenHeight] 设计实际比:[${_screenWRatio.toStringAsFixed(2)}, ${_screenHRatio.toStringAsFixed(2)}]');
      // print("_screenHeight:" + _screenHeight.toString());
    }
  }

  reset() {
    _mediaQueryData = null;
    // _appBarHeight = kToolbarHeight;
    // print("_screenWidth:" + _screenWidth.toString());
    // print("_screenHeight:" + _screenHeight.toString());
  }

  /// 获取真实宽
  double realW(int w) {
    if (_mediaQueryData == null) {
      init();
    }
    // print('$_screenWRatio  $_screenWidth $sreenDefaultW');
    return w * _screenWRatio;
  }

  /// 获取真实高
  double realH(int h) {
    if (_mediaQueryData == null) {
      init();
    }
    // print('$_screenWRatio  $_screenWidth $sreenDefaultW');
    return h * _screenWRatio;
  }

  realWByH(int w) {
    if (_mediaQueryData == null) {
      init();
    }
    return w * _screenHRatio;
  }

  realHByH(int h) {
    if (_mediaQueryData == null) {
      init();
    }
    return h * _screenHRatio;
  }

  double get screenWidth {
    init();
    return _screenWidth;
  }

  double get screenHeight {
    init();
    return _screenHeight;
  }
}
