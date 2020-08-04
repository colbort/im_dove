import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<PwPointState> buildEffect() {
  return combineEffects(<Object, Effect<PwPointState>>{
    PwPointAction.wrongPw: _onWrongPwAction,
  });
}

void _onWrongPwAction(Action action, Context<PwPointState> ctx) {}
