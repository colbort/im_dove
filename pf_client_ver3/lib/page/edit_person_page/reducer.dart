import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditPersonState> buildReducer() {
  return asReducer(
    <Object, Reducer<EditPersonState>>{
      EditPersonAction.onChangeGender: _onChangeGender,
      EditPersonAction.onChangeName: _onChangeName,
      EditPersonAction.onSaveInfo: _onSaveInfo,
    },
  );
}

EditPersonState _onChangeGender(EditPersonState state, Action action) {
  final EditPersonState newState = state.clone();
  newState.gender = action.payload;
  return newState;
}

EditPersonState _onChangeName(EditPersonState state, Action action) {
  final EditPersonState newState = state.clone();
  newState.nickName = action.payload;
  return newState;
}

EditPersonState _onSaveInfo(EditPersonState state, Action action) {
  final EditPersonState newState = state.clone();
  newState.logo = action.payload['logo'];
  return newState;
}
