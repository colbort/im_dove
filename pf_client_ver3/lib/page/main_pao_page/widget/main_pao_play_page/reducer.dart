import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoPlayState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoPlayState>>{
      MainPaoPlayAction.action: _onAction,
    },
  );
}

MainPaoPlayState _onAction(MainPaoPlayState state, Action action) {
  final MainPaoPlayState newState = state.clone();
  return newState;
}
