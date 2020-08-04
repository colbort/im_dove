import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class RecommendPageState implements Cloneable<RecommendPageState> {
  // TabController recommendTabController;
  @override
  RecommendPageState clone() {
    return RecommendPageState();
  }
}

RecommendPageState initState(Map<String, dynamic> args) {
  return RecommendPageState();
}

class RecommendPageStateStf extends ComponentState<RecommendPageState>
    with SingleTickerProviderStateMixin {}
