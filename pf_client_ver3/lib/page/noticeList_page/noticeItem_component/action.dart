import 'package:fish_redux/fish_redux.dart';

enum NoticeItemAction { action }

class NoticeItemActionCreator {
  static Action onAction() {
    return const Action(NoticeItemAction.action);
  }
}
