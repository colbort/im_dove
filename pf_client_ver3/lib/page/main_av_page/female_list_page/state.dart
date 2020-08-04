import 'package:app/widget/common/BasicTabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class FemaleListPageState implements Cloneable<FemaleListPageState> {
  var famaleListMap;
  List letters;
  int lettersSelected;
  String domain;
  GlobalKey<BasicTabsState> tabkey;
  @override
  FemaleListPageState clone() {
    return FemaleListPageState()
      ..famaleListMap = famaleListMap
      ..letters = letters
      ..domain = domain
      ..tabkey = tabkey
      ..lettersSelected = lettersSelected;
  }
}

FemaleListPageState initState(Map<String, dynamic> args) {
  GlobalKey<BasicTabsState> tabKey = GlobalKey<BasicTabsState>();
  return FemaleListPageState()
    ..domain = ''
    ..famaleListMap = {}
    ..tabkey = tabKey
    ..letters = [];
}
