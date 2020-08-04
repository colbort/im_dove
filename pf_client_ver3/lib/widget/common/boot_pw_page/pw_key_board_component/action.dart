import 'package:fish_redux/fish_redux.dart';

enum PwKeyBoardAction { keyTyped }

class PwKeyBoardActionCreator {
  static Action onKeyTypedAction(String sKeyText) {
    return Action(PwKeyBoardAction.keyTyped, payload: sKeyText);
  }
}
