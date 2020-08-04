import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoCommentListState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoCommentListState>>{
      MainPaoCommentListAction.action: _onAction,
    },
  );
}

MainPaoCommentListState _onAction(MainPaoCommentListState state, Action action) {
  final MainPaoCommentListState newState = state.clone();
  return newState;
}
