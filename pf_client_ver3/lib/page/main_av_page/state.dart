import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainAvState implements Cloneable<MainAvState> {
  final ScrollController controller = ScrollController();

  @override
  MainAvState clone() {
    return MainAvState();
  }
}

MainAvState initState(Map<String, dynamic> args) {
  return MainAvState();
}
