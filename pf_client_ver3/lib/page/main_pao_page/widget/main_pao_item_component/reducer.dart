import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';
import 'dart:math' as math;

Reducer<MainPaoItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoItemState>>{
      // MainPaoItemAction.action: _onAction,
      MainPaoItemAction.attention: _attention,
      MainPaoItemAction.expand: _expand,
      MainPaoItemAction.collect: _collect,
      MainPaoItemAction.like: _like,
      MainPaoItemAction.changeTotalComent: _changeTotalComent,
      MainPaoItemAction.buyPost: _buyPost,
    },
  );
}

// MainPaoItemState _onAction(MainPaoItemState state, Action action) {
//   final MainPaoItemState newState = state.clone();
//   return newState;
// }
MainPaoItemState _buyPost(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.isBuy = true;
    return newState;
  }
  return state;
}

MainPaoItemState _attention(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.bAttention = !newState.paoDataModel.bAttention;
    return newState;
  }
  return state;
}

MainPaoItemState _expand(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.bExpand = !newState.paoDataModel.bExpand;
    return newState;
  }
  return state;
}

MainPaoItemState _collect(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.isCollect = !newState.paoDataModel.isCollect;
    var sum = newState.paoDataModel.totalCollect;
    sum = newState.paoDataModel.isCollect ? sum + 1 : sum - 1;
    newState.paoDataModel.totalCollect = math.max(0, sum);
    return newState;
  }
  return state;
}

MainPaoItemState _like(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.isLike = !newState.paoDataModel.isLike;
    var sum = newState.paoDataModel.totalLike;
    sum = newState.paoDataModel.isLike ? sum + 1 : sum - 1;
    newState.paoDataModel.totalLike = math.max(0, sum);
    return newState;
  }
  return state;
}

MainPaoItemState _changeTotalComent(MainPaoItemState state, Action action) {
  var id = action.payload;
  if (id == state.paoDataModel.no) {
    final MainPaoItemState newState = state.clone();
    newState.paoDataModel.totalComment += 1;
    return newState;
  }
  return state;
}
