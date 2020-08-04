import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BootState> buildReducer() {
  return asReducer(
    <Object, Reducer<BootState>>{
      BootAction.countDown: _onCountDownAction,
      BootAction.fresh: _onFreshAction,
      BootAction.adInfo: _onAdInfoAction,
      BootAction.freshAniState: _onFreshAniState,
    },
  );
}

BootState _onCountDownAction(BootState state, Action action) {
  final BootState newState = state.clone();
  newState.countDown = action.payload;
  return newState;
}

BootState _onFreshAction(BootState state, Action action) {
  final BootState newState = state.clone();
  newState.countDown = false;
  newState.countSeconds = 5;
  newState.showingAni = true;
  return newState;
}

BootState _onFreshAniState(BootState state, Action action) {
  final BootState newState = state.clone();
  newState.showingAni = action.payload;
  return newState;
}

BootState _onAdInfoAction(BootState state, Action action) {
  final BootState newState = state.clone();
  newState.getAdImg = action.payload['getAdImg'];
  newState.adImgUrl = action.payload['adImgUrl'];
  newState.jumpUrl = action.payload['jumpUrl'];
  return newState;
}
