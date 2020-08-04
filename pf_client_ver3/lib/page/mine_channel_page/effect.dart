import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MineChannelState> buildEffect() {
  return combineEffects(<Object, Effect<MineChannelState>>{
    MineChannelAction.action: _onAction,
  });
}

void _onAction(Action action, Context<MineChannelState> ctx) {
}
