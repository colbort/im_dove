import 'package:fish_redux/fish_redux.dart';

enum EditPersonAction { onChangeGender, onChangeName, onGetInfo, onSaveInfo }

class EditPersonActionCreator {
  static Action onChangeGender(int type) {
    return Action(EditPersonAction.onChangeGender, payload: type);
  }

  static Action onChangeName(String name) {
    return Action(EditPersonAction.onChangeName, payload: name);
  }

  static Action onGetInfoAction() {
    return Action(EditPersonAction.onGetInfo);
  }

  static Action onSaveInfoAction(data) {
    return Action(EditPersonAction.onSaveInfo, payload: data);
  }
}
