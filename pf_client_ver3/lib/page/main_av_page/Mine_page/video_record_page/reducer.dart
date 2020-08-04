import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoRecordState>>{
      VideoRecordAction.update: _onUpdate,
    },
  );
}

VideoRecordState _onUpdate(VideoRecordState state, Action action) {
  return state.clone()..records = action.payload;
}
