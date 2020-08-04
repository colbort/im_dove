import 'dart:async';

import 'package:app/player/video_player/custom_video_control.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

//自动隐藏ui的定时器
Timer aotuHideTimer;

class VideoComState implements Cloneable<VideoComState> {
  bool isShowVideoTopUi = false;
  String videoUrl;
  GlobalKey globalKey;
  Function(CustomVideoController) updateCallBack;
  bool canWatch = true;
  int reason;
  String price;
  double wallet;
  //已播放时长(秒)
  int playedTime;

  @override
  VideoComState clone() {
    return VideoComState()
      ..isShowVideoTopUi = isShowVideoTopUi
      ..videoUrl = videoUrl
      ..globalKey = globalKey
      ..updateCallBack = updateCallBack
      ..canWatch = canWatch
      ..reason = reason
      ..price = price
      ..wallet = wallet
      ..playedTime = playedTime;
  }
}
