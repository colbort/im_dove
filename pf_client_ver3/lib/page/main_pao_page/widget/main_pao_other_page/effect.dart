import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoOtherState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoOtherState>>{
    MainPaoOtherAction.action: _onAction,
    Lifecycle.initState: _initState,
    MainPaoOtherAction.onMyPostLoadMore: _onMyPostLoadMore,
    MainPaoOtherAction.onMyPostRefresh: _onMyPostRefresh,
    MainPaoOtherAction.onMyRePlysLoadMore: _onMyRePlysLoadMore,
    MainPaoOtherAction.onMyRePlysRefresh: _onMyRePlysRefresh,
    MainPaoOtherAction.onMyFav2BuyLoadMore: _onMyFav2BuyLoadMore,
    MainPaoOtherAction.onMyFav2BuyRefresh: _onMyFav2BuyRefresh,
  });
}

void _onAction(Action action, Context<MainPaoOtherState> ctx) {}

Future<void> _initState(Action action, Context<MainPaoOtherState> ctx) async {
  var res = await Future.wait([
    _getUserDataNet(ctx.state.userId),
    _getPostsDataNet(ctx.state.userId, 0, PAGE_SIZE),
  ]);
  var resp0 = res[0];
  var resp1 = res[1];
  var bToast = false;
  if (resp1.code == 200) {
    if (resp1.data != null) {
      var list = getPaoDataModelList(resp1.data["posts"]);
      ctx.dispatch(MainPaoOtherActionCreator.myPostRefresh(list));
    }
  } else {
    bToast = true;
  }

  if (resp0.code == 200) {
    var list = PaoUserDataModel.fromJson(resp0.data);
    ctx.dispatch(MainPaoOtherActionCreator.getUserdata(list));
  } else {
    bToast = true;
  }
  if (bToast) {
    showToast(Lang.LOAD_FAILED);
  }
}

Future<void> _onMyPostLoadMore(
    Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getPostsDataNet(
      ctx.state.userId, ctx.state.myReleaseList.length, PAGE_SIZE);
  ctx.state.myPostRefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoOtherActionCreator.myPostLoadMore(list));
  // Future.delayed(Duration(seconds: 2), () {
  //   var data = createUserData();
  //   var d = createPaoDataModel(5);
  //   var d1 = createPaoDataModel(6);
  //   ctx.state.myReleaseList = d1.map((f) {
  //     return MainPaoItemState()..paoDataModel = f;
  //   }).toList();
  //   ctx.state.buyOrCollectList = d.map((f) {
  //     return MainPaoItemState()..paoDataModel = f;
  //   }).toList();
  //   ctx.dispatch(MainPaoOtherActionCreator.getUserdata(data));
  // });
}

Future<void> _onMyPostRefresh(
    Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getPostsDataNet(ctx.state.userId, 0, PAGE_SIZE);
  var resp1 = await _getUserDataNet(ctx.state.userId);
  if (resp1.code == 200) {
    var data = PaoUserDataModel.fromJson(resp1.data);
    ctx.state.paoUserData = data;
  }

  ctx.state.myPostRefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoOtherActionCreator.myPostRefresh(list));
  // Future.delayed(Duration(seconds: 2), () {
  //   var data = createUserData();
  //   var d = createPaoDataModel(5);
  //   var d1 = createPaoDataModel(6);
  //   ctx.state.myReleaseList = d1.map((f) {
  //     return MainPaoItemState()..paoDataModel = f;
  //   }).toList();
  //   ctx.state.buyOrCollectList = d.map((f) {
  //     return MainPaoItemState()..paoDataModel = f;
  //   }).toList();
  //   ctx.dispatch(MainPaoOtherActionCreator.getUserdata(data));
  // });
}

Future<void> _onMyRePlysLoadMore(
    Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getCommentDataNet(
      ctx.state.userId, ctx.state.commentList.length, PAGE_SIZE);
  ctx.state.myReplysRefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoCommentModelList(res.data["replys"]);
  ctx.dispatch(MainPaoOtherActionCreator.myRePlysLoadMore(list));
}

void _onMyRePlysRefresh(Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getCommentDataNet(ctx.state.userId, 0, PAGE_SIZE);
  ctx.state.myReplysRefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoCommentModelList(res.data["replys"]);
  ctx.dispatch(MainPaoOtherActionCreator.myRePlysRefresh(list));
}

void _onMyFav2BuyLoadMore(Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getBuyDataNet(
      ctx.state.userId, ctx.state.commentList.length, PAGE_SIZE);
  ctx.state.myFav2BuyrefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoOtherActionCreator.myFav2BuyLoadMore(list));
}

void _onMyFav2BuyRefresh(Action action, Context<MainPaoOtherState> ctx) async {
  var res = await _getBuyDataNet(ctx.state.userId, 0, PAGE_SIZE);
  ctx.state.myFav2BuyrefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) {
    ctx.dispatch(MainPaoOtherActionCreator.myFav2BuyRefresh([]));
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoOtherActionCreator.myFav2BuyRefresh(list));
}

//**********************网络******************************** */

/// 获取用户数据
Future _getUserDataNet(int userId) async {
  Map<String, dynamic> args = {"id": userId};
  var routes = Routers.USER_TARGET_BASE_INFO_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取帖子数据
Future _getPostsDataNet(int userId, int skip, int pageSize) async {
  Map<String, dynamic> args = {"id": userId, "skip": skip, "limit": pageSize};
  var routes = Routers.POSTS_TARGET_LIST_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取评论数据
Future _getCommentDataNet(int userId, int skip, int pageSize) async {
  Map<String, dynamic> args = {"id": userId, "skip": skip, "limit": pageSize};
  var routes = Routers.POSTS_TARGET_REPLYS_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取收藏购买数据
Future _getBuyDataNet(int userId, int skip, int pageSize) async {
  Map<String, dynamic> args = {"id": userId, "skip": skip, "limit": pageSize};
  var routes = Routers.POSTS_TARGET_FAV_BUY_POSTS_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}
