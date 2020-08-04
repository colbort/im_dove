import 'package:fish_redux/fish_redux.dart';

enum BootPwAction { delTypedPw, addTypedPw, resetPw, chgShowing }

class BootPwActionCreator {
  static Action onDelTypedPwAction() {
    return Action(BootPwAction.delTypedPw);
  }

  static Action onAddTypedPwAction(String pw) {
    return Action(BootPwAction.addTypedPw, payload: pw);
  }

  static Action onResetPwAction(bool status) {
    return Action(BootPwAction.resetPw, payload: status);
  }

  static Action onChgShowingAction(bool status) {
    return Action(BootPwAction.chgShowing, payload: status);
  }
}
