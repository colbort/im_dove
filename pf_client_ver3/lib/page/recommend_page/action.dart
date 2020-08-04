import 'package:fish_redux/fish_redux.dart';

enum RecommandPageAction {
  refreshUI,
}

class RecommandPageActionCreator {
  static Action onRefresh() {
    return const Action(
      RecommandPageAction.refreshUI,
    );
  }
}
