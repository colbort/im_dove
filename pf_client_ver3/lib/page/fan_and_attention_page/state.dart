import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FanAndAttentionState implements Cloneable<FanAndAttentionState> {
  TabController controller;
  int screenType;
  List fanList;
  RefreshController refreshController;
  List attentionList;
  bool isInit = true;
  var id;
  var currentId;
  @override
  FanAndAttentionState clone() {
    return FanAndAttentionState()
      ..screenType = screenType
      ..fanList = fanList
      ..attentionList = attentionList
      ..refreshController = refreshController
      ..id = id
      ..isInit = isInit
      ..currentId = currentId
      ..controller = controller;
  }
}

FanAndAttentionState initState(Map<String, dynamic> args) {
  RefreshController refreshController = RefreshController();

  return FanAndAttentionState()
    ..screenType = args != null ? args['type'] : 0
    ..id = args['id']
    ..isInit = true
    ..fanList = []
    ..refreshController = refreshController
    ..attentionList = [];
}
