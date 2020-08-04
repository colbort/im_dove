import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<WebviewState> buildEffect() {
  return combineEffects(
      <Object, Effect<WebviewState>>{Lifecycle.didUpdateWidget: _onResetView});
}

void _onResetView(Action action, Context<WebviewState> ctx) {
  Future.delayed(Duration(milliseconds: 500), () {
    ctx.dispatch(WebviewActionCreator.onChangeView(true));
  });
}
