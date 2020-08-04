import 'package:fish_redux/fish_redux.dart';

enum MainPaoCommentListAction { action }

class MainPaoCommentListActionCreator {
  static Action onAction() {
    return const Action(MainPaoCommentListAction.action);
  }
}
