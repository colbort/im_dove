import 'package:fish_redux/fish_redux.dart';

enum EditImgAction { onGetInfo, onSaveInfo }

class EditImgActionCreator {
  static Action onGetInfoAction() {
    return Action(EditImgAction.onGetInfo);
  }

  static Action onSaveInfoAction(data) {
    return Action(EditImgAction.onSaveInfo, payload: data);
  }
}
