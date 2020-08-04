import 'package:fish_redux/fish_redux.dart';

enum WebviewAction { onChangeView }

class WebviewActionCreator {
  static Action onChangeView(bool status) {
    return Action(WebviewAction.onChangeView, payload: status);
  }
}
