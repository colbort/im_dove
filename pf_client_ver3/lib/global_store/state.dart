import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

abstract class GlobalBaseState {
  Color themeColor;
  bool didLogin;
}

class GlobalState implements GlobalBaseState, Cloneable<GlobalState> {
  @override
  GlobalState clone() {
    return GlobalState()
      ..themeColor = themeColor
      ..didLogin = didLogin;
  }

  @override
  bool didLogin;

  @override
  Color themeColor;
}
