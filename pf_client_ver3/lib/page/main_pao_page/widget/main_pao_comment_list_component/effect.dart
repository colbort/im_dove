import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoCommentListState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoCommentListState>>{
    MainPaoCommentListAction.action: _onAction,
  });
}

void _onAction(Action action, Context<MainPaoCommentListState> ctx) {
}
