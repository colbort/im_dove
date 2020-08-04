import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<NoticeItemState> buildEffect() {
  return combineEffects(<Object, Effect<NoticeItemState>>{
    NoticeItemAction.action: _onAction,
  });
}

void _onAction(Action action, Context<NoticeItemState> ctx) {
}
