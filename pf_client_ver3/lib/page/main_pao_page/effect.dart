import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoState>>{
    Lifecycle.initState: _initState,
    MainPaoAction.action: _onAction,
  });
}

void _onAction(Action action, Context<MainPaoState> ctx) {}

void _initState(Action action, Context<MainPaoState> ctx) {
  if (tabController != null) {}
}
