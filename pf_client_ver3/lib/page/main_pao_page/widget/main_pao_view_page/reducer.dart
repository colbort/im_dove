import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoViewState>>{
      // MainPaoViewAction.action: _onAction,
      MainPaoViewAction.refresh: _refresh,
      MainPaoViewAction.loadMore: _loadMore,
      MainPaoViewAction.attention: _attention,
      MainPaoViewAction.userRefresh: _userRefresh,
      MainPaoViewAction.userLoadMore: _userLoadMore,
    },
  );
}

// MainPaoViewState _onAction(MainPaoViewState state, Action action) {
//   final MainPaoViewState newState = state.clone();
//   return newState;
// }

/// 加载更多
MainPaoViewState _refresh(MainPaoViewState state, Action action) {
  final MainPaoViewState newState = state.clone();
  List<PaoDataModel> list = action.payload;
  newState.dataList = [];
  list.forEach((f) {
    var d1 = MainPaoItemState();
    d1.paoDataModel = f;
    newState.dataList.add(d1);
  });
  if (list.length < PAGE_SIZE) newState.refreshController.loadNoData();
  return newState;
}

/// 加载更多
MainPaoViewState _loadMore(MainPaoViewState state, Action action) {
  final MainPaoViewState newState = state.clone();
  List<PaoDataModel> list = action.payload;

  if (newState.dataList == null) newState.dataList = [];
  list.forEach((f) {
    var d1 = MainPaoItemState();
    d1.paoDataModel = f;
    newState.dataList.add(d1);
  });
  if (list.length < PAGE_SIZE) newState.refreshController.loadNoData();
  return newState;
}

/// 加载更多
MainPaoViewState _userRefresh(MainPaoViewState state, Action action) {
  final MainPaoViewState newState = state.clone();
  List<PaoBloggerModel> list = action.payload;
  newState.dataList = [];
  newState.bloggerItemList = list;
  return newState;
}

/// 加载更多
MainPaoViewState _userLoadMore(MainPaoViewState state, Action action) {
  final MainPaoViewState newState = state.clone();
  List<PaoBloggerModel> list = action.payload;

  if (newState.bloggerItemList == null) newState.dataList = [];

  newState.bloggerItemList.addAll(list);
  return newState;
}

/// 博主关注
MainPaoViewState _attention(MainPaoViewState state, Action action) {
  final MainPaoViewState newState = state.clone();
  var userId = action.payload;
  var len = newState.bloggerItemList.length;
  for (var i = 0; i < len; i++) {
    var d = newState.bloggerItemList[i];
    if (d.userId == userId) {
      d.bWatch = !d.bWatch;
      break;
    }
  }
  return newState;
}
