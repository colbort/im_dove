import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NoticeItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<NoticeItemState>>{
      NoticeItemAction.action: _onAction,
    },
  );
}

NoticeItemState _onAction(NoticeItemState state, Action action) {
  final NoticeItemState newState = state.clone();
  return newState;
}
