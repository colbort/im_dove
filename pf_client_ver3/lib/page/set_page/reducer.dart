import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SetPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<SetPageState>>{
      SetPageAction.changePwChecked: _onChangePwChecked,
      SetPageAction.saveVersion: _onSaveVersion,
      SetPageAction.saveImageCache: _onSaveImageChche,
      SetPageAction.changePhone: _onChangePhone
    },
  );
}

SetPageState _onChangePwChecked(SetPageState state, Action action) {
  final SetPageState newState = state.clone();
  newState.pwChecked = action.payload;
  return newState;
}

SetPageState _onChangePhone(SetPageState state, Action action) {
  final SetPageState newState = state.clone();
  newState.phoneNumber = action.payload;
  return newState;
}

SetPageState _onSaveVersion(SetPageState state, Action action) {
  final SetPageState newState = state.clone();
  newState.version = action.payload;
  return newState;
}

SetPageState _onSaveImageChche(SetPageState state, Action action) {
  final SetPageState newState = state.clone();
  newState.imageCache = action.payload;
  return newState;
}
