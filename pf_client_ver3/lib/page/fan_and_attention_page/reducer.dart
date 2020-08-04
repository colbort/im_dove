import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FanAndAttentionState> buildReducer() {
  return asReducer(
    <Object, Reducer<FanAndAttentionState>>{
      FanAndAttentionAction.initController: _onInitController,
      FanAndAttentionAction.action: _onAction,
      FanAndAttentionAction.changeScreenName: _changeScreenName,
      FanAndAttentionAction.saveFanList: _saveFanList,
      FanAndAttentionAction.saveAttentionList: _saveAttentionList,
    },
  );
}

FanAndAttentionState _onAction(FanAndAttentionState state, Action action) {
  final FanAndAttentionState newState = state.clone();
  return newState;
}

FanAndAttentionState _onInitController(
    FanAndAttentionState state, Action action) {
  final FanAndAttentionState newState = state.clone();
  newState.controller = action.payload;
  return newState;
}

FanAndAttentionState _changeScreenName(
    FanAndAttentionState state, Action action) {
  final FanAndAttentionState newState = state.clone();
  newState.screenType = action.payload;
  return newState;
}

FanAndAttentionState _saveFanList(FanAndAttentionState state, Action action) {
  final FanAndAttentionState newState = state.clone();
  newState.fanList =
      action.payload['data'] != null ? action.payload['data'] : [];
  newState.isInit = false;
  newState.currentId = action.payload['masterUserId'];
  return newState;
}

FanAndAttentionState _saveAttentionList(
    FanAndAttentionState state, Action action) {
  final FanAndAttentionState newState = state.clone();
  newState.attentionList =
      action.payload['data'] != null ? action.payload['data'] : [];
  newState.isInit = false;
  newState.currentId = action.payload['masterUserId'];
  return newState;
}
