import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditImgState> buildReducer() {
  return asReducer(
    <Object, Reducer<EditImgState>>{
      EditImgAction.onSaveInfo: _onSaveInfo,
    },
  );
}

EditImgState _onSaveInfo(EditImgState state, Action action) {
  final EditImgState newState = state.clone();
  newState.image = action.payload['logo'];
  return newState;
}
