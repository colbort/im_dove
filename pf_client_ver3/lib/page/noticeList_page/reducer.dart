import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NoticeListState> buildReducer() {
  return asReducer(
    <Object, Reducer<NoticeListState>>{
      NoticeListAction.saveNoticeList: _saveNoticeList,
    },
  );
}

NoticeListState _saveNoticeList(NoticeListState state, Action action) {
  final NoticeListState newState = state.clone();
  newState.isInit = false;
  newState.list = action.payload;

  return newState;
}
