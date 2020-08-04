import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoMineState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoMineState>>{
      // MainPaoMineAction.action: _onAction,
      MainPaoMineAction.getUserdata: _getUserdata,
      MainPaoMineAction.myPostLoadMore: _myPostLoadMore,
      MainPaoMineAction.myPostRefresh: _myPostRefresh,
      MainPaoMineAction.myRePlysLoadMore: _myRePlysLoadMore,
      MainPaoMineAction.myRePlysRefresh: _myRePlysRefresh,
      MainPaoMineAction.myFav2BuyLoadMore: _myFav2BuyLoadMore,
      MainPaoMineAction.myFav2BuyRefresh: _myFav2BuyRefresh,
      MainPaoMineAction.updateSign: _updateSign,
      MainPaoMineAction.updateUserBgImg: _updateUserBgImg,
    },
  );
}

// MainPaoMineState _onAction(MainPaoMineState state, Action action) {
//   final MainPaoMineState newState = state.clone();
//   return newState;
// }

MainPaoMineState _updateUserBgImg(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  var d = action.payload;
  var data = getMineModel();
  newState.paoUserData.bgImg = d;
  data.bgImg = d;
  return newState;
}

MainPaoMineState _updateSign(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  var text = action.payload;
  var data = getMineModel();
  newState.paoUserData.intro = text;
  data.sign = text;
  return newState;
}

MainPaoMineState _getUserdata(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  newState.paoUserData = action.payload;
  return newState;
}

/// 我的帖子
MainPaoMineState _myPostLoadMore(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  List<PaoDataModel> data = action.payload;
  if (newState.myReleaseList == null) newState.myReleaseList = [];
  newState.myReleaseList.addAll(data.map((f) {
    f.bSelf = true;
    f.isBuy = true;
    return MainPaoItemState()..paoDataModel = f;
  }).toList());
  if (data.length < PAGE_SIZE) {
    state.myReplysRefreshController.loadNoData();
  }
  return newState;
}

/// 我的帖子
MainPaoMineState _myPostRefresh(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  List<PaoDataModel> data = action.payload;
  newState.myReleaseList = [];
  newState.myReleaseList.addAll(data.map((f) {
    f.bSelf = true;
    f.isBuy = true;
    return MainPaoItemState()..paoDataModel = f;
  }).toList());
  if (data.length < PAGE_SIZE) {
    state.myPostRefreshController.loadNoData();
  }
  return newState;
}

/// 我的评论
MainPaoMineState _myRePlysLoadMore(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  List<PaoCommentModel> data = action.payload;
  if (newState.commentList == null) newState.commentList = [];
  newState.commentList.addAll(data);
  if (data.length < PAGE_SIZE) {
    state.myPostRefreshController.loadNoData();
  }
  return newState;
}

/// 我的评论
MainPaoMineState _myRePlysRefresh(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  List<PaoCommentModel> data = action.payload;
  newState.commentList = [];
  newState.commentList.addAll(data);
  if (data.length < PAGE_SIZE) {
    state.myReplysRefreshController.loadNoData();
  }
  return newState;
}

/// 我的收藏购买记录
MainPaoMineState _myFav2BuyLoadMore(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
  List data = action.payload;
  if (newState.buyOrCollectList == null) newState.buyOrCollectList = [];
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

/// 我的收藏购买记录
MainPaoMineState _myFav2BuyRefresh(MainPaoMineState state, Action action) {
  final MainPaoMineState newState = state.clone();
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
