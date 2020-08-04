import 'package:app/pojo/av_data.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CalssifyState> buildReducer() {
  return asReducer(
    <Object, Reducer<CalssifyState>>{
      CalssifyAction.classify: _onClassify,
      CalssifyAction.videos: _onVideos,
      CalssifyAction.toggleTitle: _toggleTitle,
      CalssifyAction.clearVideos: _clearVideos,
      CalssifyAction.changeTag: _changeTag
    },
  );
}

CalssifyState _changeTag(CalssifyState state, Action action) {
  var newState = state.clone();
  var i = action.payload['index'];
  ClassifyBean data = action.payload['data'];
  newState.selected.removeAt(i);
  newState.selected.insert(i, data);
  return newState;
}

CalssifyState _clearVideos(CalssifyState state, Action action) {
  var newState = state.clone();
  newState.videos.videos = List();
  return newState;
}

CalssifyState _toggleTitle(CalssifyState state, Action action) {
  return state.clone()..showTitle = action.payload;
}

CalssifyState _onClassify(CalssifyState state, Action action) {
  return state.clone()..classify = action.payload;
}

CalssifyState _onVideos(CalssifyState state, Action action) {
  var newState = state.clone();
  newState.videos.videos.addAll(action.payload);
  return newState;
}
