import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoMineState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoMineState>>{
    // MainPaoMinAction.action: _onAction,
    Lifecycle.initState: _initState,
    MainPaoMineAction.onMyPostLoadMore: _onMyPostLoadMore,
    MainPaoMineAction.onMyPostRefresh: _onMyPostRefresh,
    MainPaoMineAction.onMyRePlysLoadMore: _onMyRePlysLoadMore,
    MainPaoMineAction.onMyRePlysRefresh: _onMyRePlysRefresh,
    MainPaoMineAction.onMyFav2BuyLoadMore: _onMyFav2BuyLoadMore,
    MainPaoMineAction.onMyFav2BuyRefresh: _onMyFav2BuyRefresh,
    MainPaoMineAction.onUpdateSign: _onUpdateSign,
    MainPaoMineAction.onUpdateUserBgImg: _onUpdateUserBgImg,
  });
}

// void _onAction(Action action, Context<MainPaoMineState> ctx) {}
void _onUpdateUserBgImg(Action action, Context<MainPaoMineState> ctx) {
  var data = action.payload;
  ctx.dispatch(MainPaoMineActionCreator.updateUserBgImg(data));
}

Future<void> _onUpdateSign(Action action, Context<MainPaoMineState> ctx) async {
  var text = action.payload;
  var resp = await _sendUpdteSignNet(text);
  if (resp.code != Code.SUCCESS) {
    showToast(Lang.SIGN_FAILD);
    return;
  }
  ctx.dispatch(MainPaoMineActionCreator.updateSign(text));
}

Future<void> _initState(Action action, Context<MainPaoMineState> ctx) async {
  var mineData = getMineModel();
  if (mineData == null) {
    showToast(Lang.WANGLUOCUOWU);
    return;
  }
  var res = await Future.wait([
    _getUserDataNet(mineData.userId),
    _getPostsDataNet(0, PAGE_SIZE),
  ]);
  var resp0 = res[0];
  var resp1 = res[1];
  var bToast = false;
  if (resp1.code == 200) {
    if (resp1.data != null) {
      var list = getPaoDataModelList(resp1.data["posts"]);
      ctx.dispatch(MainPaoMineActionCreator.myPostRefresh(list));
    }
  } else {
    bToast = true;
  }

  if (resp0.code == 200) {
    var list = PaoUserDataModel.fromJson(resp0.data);
    ctx.dispatch(MainPaoMineActionCreator.getUserdata(list));
  } else {
    bToast = true;
  }
  if (bToast) {
    showToast(Lang.LOAD_FAILED);
  }
}

Future<void> _onMyPostLoadMore(
    Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getPostsDataNet(ctx.state.myReleaseList.length, PAGE_SIZE);
  ctx.state.myPostRefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoMineActionCreator.myPostLoadMore(list));
}

Future<void> _onMyPostRefresh(
    Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getPostsDataNet(0, PAGE_SIZE);
  var mineData = getMineModel();
  if (mineData != null) {
    var resp1 = await _getUserDataNet(mineData.userId);
    if (resp1.code == 200) {
      var data = PaoUserDataModel.fromJson(resp1.data);
      ctx.state.paoUserData = data;
    }
  }
  ctx.state.myPostRefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoMineActionCreator.myPostRefresh(list));
}

Future<void> _onMyRePlysLoadMore(
    Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getCommentDataNet(ctx.state.commentList.length, PAGE_SIZE);
  ctx.state.myReplysRefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoCommentModelList(res.data["replys"]);
  ctx.dispatch(MainPaoMineActionCreator.myRePlysLoadMore(list));
}

void _onMyRePlysRefresh(Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getCommentDataNet(0, PAGE_SIZE);
  ctx.state.myReplysRefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoCommentModelList(res.data["replys"]);
  ctx.dispatch(MainPaoMineActionCreator.myRePlysRefresh(list));
}

void _onMyFav2BuyLoadMore(Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getBuyDataNet(ctx.state.commentList.length, PAGE_SIZE);
  ctx.state.myFav2BuyrefreshController.loadComplete();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) return;
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoMineActionCreator.myFav2BuyLoadMore(list));
}

void _onMyFav2BuyRefresh(Action action, Context<MainPaoMineState> ctx) async {
  var res = await _getBuyDataNet(0, PAGE_SIZE);
  ctx.state.myFav2BuyrefreshController.refreshCompleted();
  if (res.code != 200) {
    showToast(Lang.LOAD_FAILED);
    return;
  }
  if (res.data == null) {
    ctx.dispatch(MainPaoMineActionCreator.myFav2BuyRefresh([]));
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoMineActionCreator.myFav2BuyRefresh(list));
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
Future _getPostsDataNet(int skip, int pageSize) async {
  var data = getMineModel();
  if (data == null) return RespData(0);
  var userId = data.userId;
  Map<String, dynamic> args = {
    "id": userId,
    "skip": skip,
    "limit": pageSize,
  };
  var routes = Routers.POSTS_TARGET_LIST_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取评论数据
Future _getCommentDataNet(int skip, int pageSize) async {
  var data = getMineModel();
  if (data == null) return RespData(0);
  var userId = data.userId;
  Map<String, dynamic> args = {
    "id": userId,
    "skip": skip,
    "limit": pageSize,
  };
  var routes = Routers.POSTS_TARGET_REPLYS_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取收藏购买数据
Future _getBuyDataNet(int skip, int pageSize) async {
  var data = getMineModel();
  if (data == null) return RespData(0);
  var userId = data.userId;
  Map<String, dynamic> args = {
    "id": userId,
    "skip": skip,
    "limit": pageSize,
  };
  var routes = Routers.POSTS_TARGET_FAV_BUY_POSTS_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取�����藏购买数据
Future _sendUpdteSignNet(String text) async {
  Map<String, dynamic> args = {"personSignature": text};
  var routes = Routers.USERHOME_UPDATE_SING_POST;
  var resp = await net.request(routes, args: args);
  return resp;
}
