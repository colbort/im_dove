import 'package:fish_redux/fish_redux.dart';

enum GlobalAction { changeThemeColor, didLogin }

class GlobalActionCreator {
  static Action onchangeThemeColor() {
    return const Action(GlobalAction.changeThemeColor);
  }

  static Action didLogin() {
    return const Action(GlobalAction.didLogin);
  }
}
