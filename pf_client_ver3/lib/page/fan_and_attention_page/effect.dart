import 'package:app/net/net.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'page.dart';
import 'state.dart';

final Map<String, dynamic> fetchFansData = {
  'page': 1,
  'pageSize': 10,
  'type': true,
  'userId': null
};

final Map<String, dynamic> fetchAttentionData = {
  'page': 1,
  'pageSize': 10,
  'type': true,
  'userId': null
};

Effect<FanAndAttentionState> buildEffect() {
  return combineEffects(<Object, Effect<FanAndAttentionState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    FanAndAttentionAction.getFanList: _getFanList,
    FanAndAttentionAction.getAttentionList: _getAttentionList,
  });
}

void _onInit(Action action, Context<FanAndAttentionState> ctx) {
  final tickerProvider = ctx.stfState as FanAndAttentionStf;
  final _controller = TabController(vsync: tickerProvider, length: 2);

  _controller.addListener(() {
    ctx.dispatch(
        FanAndAttentionActionCreator.changeScreenName(_controller.index));
  });
  _controller.animateTo(ctx.state.screenType);

  ctx.dispatch(FanAndAttentionActionCreator.initController(_controller));

  // true--当前app用户 false--其他用户
  fetchFansData['type'] = ctx.state.id != null ? false : true;
  fetchAttentionData['type'] = ctx.state.id != null ? false : true;
  fetchFansData['userId'] = ctx.state.id;
  fetchAttentionData['userId'] = ctx.state.id;

  ctx.dispatch(FanAndAttentionActionCreator.getFanList(fetchFansData));
  ctx.dispatch(
      FanAndAttentionActionCreator.getAttentionList(fetchAttentionData));
}

void _getFanList(Action action, Context<FanAndAttentionState> ctx) async {
  var resp = await net.request(Routers.FAN_LIST, args: action.payload);
  ctx.state.refreshController.refreshCompleted();
  ctx.state.refreshController.loadComplete();
  if (resp.code == 200 && resp.data != null) {
    ctx.dispatch(FanAndAttentionActionCreator.saveFanList(resp.data));
  }
}

void _getAttentionList(Action action, Context<FanAndAttentionState> ctx) async {
  var resp = await net.request(Routers.ATTENTION_LIST, args: action.payload);
  ctx.state.refreshController.refreshCompleted();
  ctx.state.refreshController.loadComplete();
  if (resp.code == 200 && resp.data != null) {
    ctx.dispatch(FanAndAttentionActionCreator.saveAttentionList(resp.data));
  }
}

void _onDispose(Action action, Context<FanAndAttentionState> ctx) async {
  ctx.state.controller?.dispose();
  fetchFansData['pageSize'] = 10;
  fetchAttentionData['pageSize'] = 10;
}
