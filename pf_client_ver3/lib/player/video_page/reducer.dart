import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoState>>{
      VideoAction.action: _onAction,
      VideoAction.showVideoDialog: _onShowVideoDialogAction,
      VideoAction.closeVideoDialog: _onCloseVideoDialogAction,
      VideoAction.freshVideoId: _onFreshVideoId,
    },
  );
}

VideoState _onAction(VideoState state, Action action) {
  final VideoState newState = state.clone();
  return newState;
}

VideoState _onShowVideoDialogAction(VideoState state, Action action) {
  final VideoState newState = state.clone();
  newState.bShowDiaog = true;
  newState.reason = action.payload['reason'];
  newState.price = action.payload['price'];
  newState.wallet = action.payload['wallet'];
  return newState;
}

VideoState _onCloseVideoDialogAction(VideoState state, Action action) {
  //设置回来
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final VideoState newState = state.clone();
  newState.bShowDiaog = false;
  return newState;
}

VideoState _onFreshVideoId(VideoState state, Action action) {
  //切换影片的时候，恢复屏幕旋转
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final VideoState newState = state.clone();
  newState.videoId = action.payload;
  newState.totalTime = 0;
  newState.playedTime = 0;
  return newState;
}
