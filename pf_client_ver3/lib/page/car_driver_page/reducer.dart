import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CarDriverState> buildReducer() {
  return asReducer(
    <Object, Reducer<CarDriverState>>{
      CarDriverAction.onSaveGroup: _onSaveGroup,
    },
  );
}

CarDriverState _onSaveGroup(CarDriverState state, Action action) {
  final CarDriverState newState = state.clone();
  newState.group = action.payload;
  return newState;
}
