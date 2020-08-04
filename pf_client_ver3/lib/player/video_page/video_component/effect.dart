import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoComState> buildEffect() {
  return combineEffects(<Object, Effect<VideoComState>>{
    VideoComAction.action: _onAction,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<VideoComState> ctx) {}

void _onDispose(Action action, Context<VideoComState> ctx) {
  aotuHideTimer?.cancel();
}
