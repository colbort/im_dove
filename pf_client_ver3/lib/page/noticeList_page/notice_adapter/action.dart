import 'package:fish_redux/fish_redux.dart';

enum NoticeAction { action }

class NoticeActionCreator {
  static Action onAction() {
    return const Action(NoticeAction.action);
  }
}
