import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoComState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoComState>>{
      VideoComAction.action: _onAction,
      VideoComAction.showVideoTopUi: _showVideoTopUi,
      VideoComAction.freshVideoUrl: _onFreshUrl,
      VideoComAction.freshUpdateCallback: _onFreshUpdateCallback,
      VideoComAction.freshPayState: _onFreshPayState,
      VideoComAction.freshCanWatch: _onFreshCanWatch,
    },
  );
}

VideoComState _onAction(VideoComState state, Action action) {
  final VideoComState newState = state.clone();
  return newState;
}

VideoComState _showVideoTopUi(VideoComState state, Action action) {
  final VideoComState newState = state.clone()
    ..isShowVideoTopUi = action.payload;
  return newState;
}

VideoComState _onFreshUrl(VideoComState state, Action action) {
  final VideoComState newState = state.clone();
  newState.videoUrl = action.payload['url'];
  newState.updateCallBack = action.payload['updateCallBack'];
  if (newState.videoUrl == null || newState.videoUrl == '') {
    newState.canWatch = true;
    newState.reason = 0;
  }
  return newState;
}

VideoComState _onFreshUpdateCallback(VideoComState state, Action action) {
  final VideoComState newState = state.clone();
  newState.updateCallBack = action.payload;
  return newState;
}

VideoComState _onFreshPayState(VideoComState state, Action action) {
  final VideoComState newState = state.clone();
  newState.canWatch = action.payload['canWatch'];
  newState.reason = action.payload['reason'];
  newState.price = action.payload['price'];
  newState.wallet = action.payload['wallet'];
  return newState;
}

VideoComState _onFreshCanWatch(VideoComState state, Action action) {
  final VideoComState newState = state.clone();
  newState.canWatch = action.payload;
  return newState;
}
