import 'package:app/pojo/id_video_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CollectionsState> buildReducer() {
  return asReducer(
    <Object, Reducer<CollectionsState>>{
      CollectionsAction.refreshOkay: _onRefreshOkay,
      CollectionsAction.loadMoreOkay: _onLoadMoreOkay,
    },
  );
}

CollectionsState _onRefreshOkay(CollectionsState state, Action action) {
  var newDatas = action.payload as List<IdVideoItemBean>;
  if ((newDatas?.length ?? 0) <= 0) return state.clone();
  final CollectionsState newState = state.clone()..datas = newDatas;
  return newState;
}

CollectionsState _onLoadMoreOkay(CollectionsState state, Action action) {
  var moreDatas = action.payload as List<IdVideoItemBean>;
  if ((moreDatas?.length ?? 0) <= 0) return state.clone();

  var newDatas = List<IdVideoItemBean>.from(state.datas);
  newDatas.addAll(moreDatas);
  final CollectionsState newState = state.clone()..datas = newDatas;
  return newState;
}
