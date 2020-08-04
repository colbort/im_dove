import 'package:fish_redux/fish_redux.dart';

enum MainPaoPlayAction { action }

class MainPaoPlayActionCreator {
  static Action onAction() {
    return const Action(MainPaoPlayAction.action);
  }
}
