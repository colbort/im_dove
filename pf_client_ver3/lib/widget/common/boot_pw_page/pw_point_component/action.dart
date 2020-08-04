import 'package:fish_redux/fish_redux.dart';

enum PwPointAction { pwTyped, wrongPw }

class PwPointActionCreator {
  static Action onPwTypedAction(int len) {
    return Action(PwPointAction.pwTyped, payload: len);
  }

  static Action onWrongPwAction() {
    return Action(PwPointAction.pwTyped);
  }
}
