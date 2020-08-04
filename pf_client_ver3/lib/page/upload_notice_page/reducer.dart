import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UploadNoticeState> buildReducer() {
  return asReducer(
    <Object, Reducer<UploadNoticeState>>{
      UploadNoticeAction.action: _onAction,
    },
  );
}

UploadNoticeState _onAction(UploadNoticeState state, Action action) {
  final UploadNoticeState newState = state.clone();
  return newState;
}
