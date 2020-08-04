import 'package:fish_redux/fish_redux.dart';
import 'state.dart';

Effect<PwKeyBoardState> buildEffect() {
  return combineEffects(<Object, Effect<PwKeyBoardState>>{
    //PwKeyBoardAction.keyTyped: _onKeyTypeAction,
  });
}

//void _onKeyTypeAction(Action action, Context<PwKeyBoardState> ctx) {}
