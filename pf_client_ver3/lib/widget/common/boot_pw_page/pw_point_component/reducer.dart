import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PwPointState> buildReducer() {
  return asReducer(
    <Object, Reducer<PwPointState>>{
      PwPointAction.pwTyped: _onPwTypedAction,
    },
  );
}

PwPointState _onPwTypedAction(PwPointState state, Action action) {
  final PwPointState newState = state.clone();
  newState.typedPwLen = action.payload;
  return newState;
}
