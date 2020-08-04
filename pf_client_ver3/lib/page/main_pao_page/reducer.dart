import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoState>>{
      MainPaoAction.action: _onAction,
      MainPaoAction.changeType: _changeType,
    },
  );
}

MainPaoState _onAction(MainPaoState state, Action action) {
  final MainPaoState newState = state.clone();
  return newState;
}

MainPaoState _changeType(MainPaoState state, Action action) {
  final MainPaoState newState = state.clone();
  var index = action.payload;
  newState.stype = index;
  return newState;
}
