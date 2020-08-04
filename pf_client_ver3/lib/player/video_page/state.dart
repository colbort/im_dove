import 'package:app/player/video_page/video_component/state.dart';
import 'package:app/player/video_page/video_info_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class VideoState implements Cloneable<VideoState> {
  VideoInfoState infoState;
  VideoComState comState;
  int videoId;
  //视频总时长(秒)
  int totalTime;
  //已播放时长(秒)
  int playedTime;
  GlobalKey videoComKey;
  //是否显示付费，vip，次数不够的对话框
  bool bShowDiaog;
  //钱包有多少钱
  double wallet;
  //价格
  String price;
  //不能观看的原因
  int reason;

  @override
  VideoState clone() {
    return VideoState()
      ..infoState = infoState
      ..comState = comState
      ..videoId = videoId
      ..totalTime = totalTime
      ..playedTime = playedTime
      ..videoComKey = videoComKey
      ..bShowDiaog = bShowDiaog
      ..wallet = wallet
      ..price = price
      ..reason = reason;
  }
}

VideoState initState(Map<String, dynamic> args) {
  var videoState = VideoState();
  videoState.infoState = VideoInfoState();
  videoState.comState = VideoComState();
  videoState.videoId = args['videoId'];
  videoState.totalTime = args['totalTime'] ?? 0;
  videoState.playedTime = args['playedTime'] ?? 0;
  videoState.videoComKey = GlobalKey();
  videoState.bShowDiaog = false;
  return videoState;
}

class VideoInfoConnector extends ConnOp<VideoState, VideoInfoState> {
  @override
  VideoInfoState get(VideoState videoState) {
    var infoState = videoState.infoState.clone();
    infoState.videoId = videoState.videoId;
    return infoState;
  }

  @override
  void set(VideoState state, VideoInfoState subState) {
    state.infoState = subState;
  }
}

class VideoComConnector extends ConnOp<VideoState, VideoComState> {
  @override
  VideoComState get(VideoState videoState) {
    var com = videoState.comState.clone();
    com.globalKey = videoState.videoComKey;
    com.playedTime = videoState.playedTime;
    return com;
  }

  @override
  void set(VideoState state, VideoComState subState) {
    state.comState = subState;
  }
}
