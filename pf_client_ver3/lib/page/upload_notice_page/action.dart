import 'package:fish_redux/fish_redux.dart';

enum UploadNoticeAction { action }

class UploadNoticeActionCreator {
  static Action onAction() {
    return const Action(UploadNoticeAction.action);
  }
}
