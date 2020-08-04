import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

enum FanAndAttentionAction {
  action,
  initController,
  changeScreenName,
  getFanList,
  getAttentionList,
  saveFanList,
  saveAttentionList
}

class FanAndAttentionActionCreator {
  static Action initController(TabController controller) {
    return Action(FanAndAttentionAction.initController, payload: controller);
  }

  static Action changeScreenName(int screenType) {
    return Action(FanAndAttentionAction.changeScreenName, payload: screenType);
  }

  static Action getFanList(dynamic params) {
    return Action(FanAndAttentionAction.getFanList, payload: params);
  }

  static Action getAttentionList(dynamic params) {
    return Action(FanAndAttentionAction.getAttentionList, payload: params);
  }

  static Action saveFanList(dynamic list) {
    return Action(FanAndAttentionAction.saveFanList, payload: list);
  }

  static Action saveAttentionList(dynamic list) {
    return Action(FanAndAttentionAction.saveAttentionList, payload: list);
  }
}
