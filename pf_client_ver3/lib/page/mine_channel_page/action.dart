import 'package:fish_redux/fish_redux.dart';

enum MineChannelAction { action }

class MineChannelActionCreator {
  static Action onAction() {
    return const Action(MineChannelAction.action);
  }
}
