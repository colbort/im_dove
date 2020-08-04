import 'package:fish_redux/fish_redux.dart';

class MainState implements Cloneable<MainState> {
  int index;
  // bool showFloatingActionButton;
  // bool isShowFullFloatingActionButton = true;
  bool showUpdater;
  bool isAlowedBackApp;
  @override
  MainState clone() {
    return MainState()
      ..index = index
      ..showUpdater = showUpdater
      ..isAlowedBackApp = isAlowedBackApp;
    // ..isShowFullFloatingActionButton = isShowFullFloatingActionButton
    // ..showFloatingActionButton = showFloatingActionButton;
  }
}

MainState initState(Map<String, dynamic> args) {
  return MainState()
    ..index = 0
    ..showUpdater = false
    ..isAlowedBackApp = true;
  // ..showFloatingActionButton = false;
}
