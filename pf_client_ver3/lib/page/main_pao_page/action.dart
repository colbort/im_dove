import 'package:fish_redux/fish_redux.dart';

enum MainPaoAction {
  action,
  changeType,

  /// 初始化数据
  onInitData,
}

class MainPaoActionCreator {
  static Action onAction() {
    return const Action(MainPaoAction.action);
  }

  static Action onInitData(int index) {
    return Action(MainPaoAction.onInitData, payload: index);
  }
}
