import 'package:fish_redux/fish_redux.dart';

enum MineAction { action }

class MineActionCreator {
  static Action onAction() {
    return const Action(MineAction.action);
  }
}
