import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoOtherState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoOtherState>>{
      MainPaoOtherAction.action: _onAction,
      MainPaoOtherAction.getUserdata: _getUserdata,
      MainPaoOtherAction.myPostLoadMore: _myPostLoadMore,
      MainPaoOtherAction.myPostRefresh: _myPostRefresh,
      MainPaoOtherAction.myRePlysLoadMore: _myRePlysLoadMore,
      MainPaoOtherAction.myRePlysRefresh: _myRePlysRefresh,
      MainPaoOtherAction.myFav2BuyLoadMore: _myFav2BuyLoadMore,
      MainPaoOtherAction.myFav2BuyRefresh: _myFav2BuyRefresh,
    },
  );
}

MainPaoOtherState _onAction(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  return newState;
}

MainPaoOtherState _getUserdata(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  newState.paoUserData = action.payload;
  return newState;
}

/// 我的帖子
MainPaoOtherState _myPostLoadMore(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List data = action.payload;
  if (newState.myReleaseList == null) newState.myReleaseList = [];
  newState.myReleaseList.addAll(data.map((f) {
    return MainPaoItemState()
      ..paoDataModel = f
      ..bShowUserData = false;
  }).toList());
  if (data.length < PAGE_SIZE) {
    newState.myReplysRefreshController.loadNoData();
  }
  return newState;
}

/// 我的帖子
MainPaoOtherState _myPostRefresh(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List<PaoDataModel> data = action.payload;
  newState.myReleaseList = [];
  newState.myReleaseList.addAll(data.map((f) {
    return MainPaoItemState()
      ..paoDataModel = f
      ..bShowUserData = false;
  }).toList());
  if (data.length < PAGE_SIZE) {
    newState.myPostRefreshController.loadNoData();
  }
  return newState;
}

/// 我的评论
MainPaoOtherState _myRePlysLoadMore(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List<PaoCommentModel> data = action.payload;
  if (newState.commentList == null) newState.commentList = [];
  newState.commentList.addAll(data);
  if (data.length < PAGE_SIZE) {
    newState.myPostRefreshController.loadNoData();
  }
  return newState;
}

/// 我的评论
MainPaoOtherState _myRePlysRefresh(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List<PaoCommentModel> data = action.payload;
  newState.commentList = [];
  newState.commentList.addAll(data);
  if (data.length < PAGE_SIZE) {
    newState.myReplysRefreshController.loadNoData();
  }
  return newState;
}

/// 我的收藏购买记录
MainPaoOtherState _myFav2BuyLoadMore(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List data = action.payload;
  if (newState.buyOrCollectList == null) newState.buyOrCollectList = [];
  newState.buyOrCollectList.addAll(data.map((f) {
    return MainPaoItemState()
      ..paoDataModel = f
      ..bShowUserData = false;
  }).toList());
  if (data.length < PAGE_SIZE) {
    newState.myFav2BuyrefreshController.loadNoData();
  }
  return newState;
}

/// 我的收藏购买记录
MainPaoOtherState _myFav2BuyRefresh(MainPaoOtherState state, Action action) {
  final MainPaoOtherState newState = state.clone();
  List data = action.payload;
  newState.buyOrCollectList = [];
  newState.buyOrCollectList.addAll(data.map((f) {
    return MainPaoItemState()
      ..paoDataModel = f
      ..bShowUserData = false;
  }).toList());
  if (data.length < PAGE_SIZE) {
    state.myFav2BuyrefreshController.loadNoData();
  }
  return newState;
}
