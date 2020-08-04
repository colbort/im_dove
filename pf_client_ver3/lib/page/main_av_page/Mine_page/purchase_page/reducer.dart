import 'package:app/pojo/id_video_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PurchaseState> buildReducer() {
  return asReducer(
    <Object, Reducer<PurchaseState>>{
      PurchaseAction.refreshOkay: _onRefreshOkay,
      PurchaseAction.loadMoreOkay: _onLoadMoreOkay,
    },
  );
}

PurchaseState _onRefreshOkay(PurchaseState state, Action action) {
  var newDatas = action.payload as List<IdVideoItemBean>;
  if ((newDatas?.length ?? 0) <= 0) return state.clone();
  final PurchaseState newState = state.clone()..datas = newDatas;
  return newState;
}

PurchaseState _onLoadMoreOkay(PurchaseState state, Action action) {
  var moreDatas = action.payload as List<IdVideoItemBean>;
  if ((moreDatas?.length ?? 0) <= 0) return state.clone();

  var newDatas = List<IdVideoItemBean>.from(state.datas);
  newDatas.addAll(moreDatas);
  final PurchaseState newState = state.clone()..datas = newDatas;
  return newState;
}
