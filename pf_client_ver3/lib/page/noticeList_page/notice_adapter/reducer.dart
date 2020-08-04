import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import '../state.dart';

Reducer<NoticeListState> buildReducer() {
  return asReducer(
    <Object, Reducer<NoticeListState>>{
      NoticeAction.action: _onAction,
    },
  );
}

NoticeListState _onAction(NoticeListState state, Action action) {
  final NoticeListState newState = state.clone();
  return newState;
}
