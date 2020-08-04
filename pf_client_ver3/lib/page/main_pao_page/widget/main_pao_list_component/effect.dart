import 'package:fish_redux/fish_redux.dart';
import 'state.dart';

Effect<MainPaoListState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoListState>>{
    // MainPaoListAction.action: _onAction,
  });
}

// void _onAction(Action action, Context<MainPaoListState> ctx) {
// }
