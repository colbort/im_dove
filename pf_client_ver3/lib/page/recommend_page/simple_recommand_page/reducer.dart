import 'package:app/pojo/video_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SimpleRecommandState> buildReducer() {
  return asReducer(
    <Object, Reducer<SimpleRecommandState>>{
      SimpleRecommandAction.refreshOkay: _onRefreshOkay,
      SimpleRecommandAction.loadMoreOkay: _onLoadMoreOkay,
      SimpleRecommandAction.autoPlayUI: _onAutoPlay,
    },
  );
}

SimpleRecommandState _onRefreshOkay(SimpleRecommandState state, Action action) {
  var newDatas = action.payload as List<VideoBean>;
  if ((newDatas?.length ?? 0) <= 0) return state.clone();
  final SimpleRecommandState newState = state.clone()..datas = newDatas;
  return newState;
}

/// 开始或者停止自动播放
/// <0的话停止所有的播放
SimpleRecommandState _onAutoPlay(SimpleRecommandState state, Action action) {
  var playIndex = action.payload as int;
  if (null == playIndex) return state;
  final SimpleRecommandState newState = state.clone()
    ..latestPlayIndex = playIndex;
  return newState;
}

SimpleRecommandState _onLoadMoreOkay(
    SimpleRecommandState state, Action action) {
  var moreDatas = action.payload as List<VideoBean>;
  if ((moreDatas?.length ?? 0) <= 0) return state.clone();

  var newDatas = List<VideoBean>.from(state.datas);
  newDatas.addAll(moreDatas);
  final SimpleRecommandState newState = state.clone()..datas = newDatas;
  return newState;
}
