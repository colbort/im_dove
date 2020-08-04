import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PhoneState> buildReducer() {
  return asReducer(
    <Object, Reducer<PhoneState>>{
      PhoneAction.getCaptcha: _getCaptcha,
      PhoneAction.scheduleTimer: _scheduleTimer,
      PhoneAction.mobileAction: _mobileAction,
    },
  );
}

PhoneState _getCaptcha(PhoneState state, Action action) {
  String captchaId = action.payload['captchaId'];
  final PhoneState newState = state.clone()..captchaId = captchaId;
  return newState;
}

PhoneState _mobileAction(PhoneState state, Action action) {
  PhoneStateType type = action.payload['type'];
  final PhoneState newState = state.clone()..type = type;
  return newState;
}

PhoneState _scheduleTimer(PhoneState state, Action action) {
  final PhoneState newState = state.clone()..countdown = state.countdown - 1;
  if (newState.countdown <= -1) {
    if (newState.timer != null && newState.timer.isActive) {
      newState.timer.cancel();
    }
  }
  return newState;
}
