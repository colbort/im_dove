import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineChannelState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineChannelState>>{
      MineChannelAction.action: _onAction,
    },
  );
}

MineChannelState _onAction(MineChannelState state, Action action) {
  final MineChannelState newState = state.clone();
  return newState;
}
