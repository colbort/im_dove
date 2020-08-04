import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BootPwState> buildReducer() {
  return asReducer(
    <Object, Reducer<BootPwState>>{
      BootPwAction.delTypedPw: _onDelTypePwAction,
      BootPwAction.addTypedPw: _onKeyTypePwAction,
      BootPwAction.resetPw: _onResetPw,
      BootPwAction.chgShowing: _onChgShow,
    },
  );
}

BootPwState _onChgShow(BootPwState state, Action action) {
  final BootPwState newState = state.clone();
  newState.isShow = action.payload;
  newState.typedPw = '';
  return newState;
}

BootPwState _onResetPw(BootPwState state, Action action) {
  final BootPwState newState = state.clone();
  newState.isShowAnimate = action.payload;
  newState.typedPw = '';
  return newState;
}

BootPwState _onDelTypePwAction(BootPwState state, Action action) {
  final BootPwState newState = state.clone();
  int len = newState.typedPw.length;
  if (len > 0) {
    newState.typedPw = newState.typedPw.substring(0, len - 1);
  }
  newState.isShowAnimate = false;
  return newState;
}

BootPwState _onKeyTypePwAction(BootPwState state, Action action) {
  final BootPwState newState = state.clone();
  if (newState.typedPw.length < 4) {
    newState.typedPw += action.payload;
  }
  return newState;
}
