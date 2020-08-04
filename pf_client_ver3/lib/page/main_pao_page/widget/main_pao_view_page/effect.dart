import 'package:app/net/net.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';
import '../../action.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoViewState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoViewState>>{
    Lifecycle.initState: _initState,
    MainPaoViewAction.onRefresh: _onRefresh,
    MainPaoViewAction.onLoadMore: _onLoadMore,
    MainPaoViewAction.onAttention: _onAttention,
    MainPaoAction.onInitData: _onInitData,
  });
}

Future<void> _onInitData(Action action, Context<MainPaoViewState> ctx) async {
  var index = action.payload;
  if (index != ctx.state.stype) return;
  if (ctx.state.dataList.length > 0) return;
  if (ctx.state.stype == 0) {
    watchListData(0, ctx);
    return;
  }
  var res = await _getListDataNet(0, PAGE_SIZE, ctx.state.stype);
  if (res.code != 200 || res.data == null) {
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoViewActionCreator.refresh(list));
}

Future<void> _initState(Action action, Context<MainPaoViewState> ctx) async {
  if (ctx.state.stype == 0) {
    watchListData(0, ctx);
    return;
  }
  var res = await _getListDataNet(0, PAGE_SIZE, ctx.state.stype);
  if (res.code != 200 || res.data == null) {
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoViewActionCreator.refresh(list));
  // Future.delayed(Duration(seconds: 2), () {
  //   var list = createPaoDataModel(ctx.state.stype);
  //   ctx.dispatch(MainPaoViewActionCreator.loadMore(list));
  // });
}

Future<void> _onRefresh(Action action, Context<MainPaoViewState> ctx) async {
  if (ctx.state.stype == 0) {
    watchListData(0, ctx);
    return;
  }
  var res = await _getListDataNet(0, PAGE_SIZE, ctx.state.stype);
  ctx.state.refreshController.refreshCompleted();
  if (res.code != 200 || res.data == null) {
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoViewActionCreator.refresh(list));
}

Future<void> _onLoadMore(Action action, Context<MainPaoViewState> ctx) async {
  if (ctx.state.stype == 0) {
    watchListData(1, ctx);
    return;
  }
  var res = await _getListDataNet(
      ctx.state.dataList.length, PAGE_SIZE, ctx.state.stype);
  ctx.state.refreshController.loadComplete();
  if (res.code != 200 || res.data == null) {
    return;
  }
  var list = getPaoDataModelList(res.data["posts"]);
  ctx.dispatch(MainPaoViewActionCreator.loadMore(list));
}

/// 关注
Future<void> _onAttention(Action action, Context<MainPaoViewState> ctx) async {
  var userId = action.payload;
  var resp = await _sendAttentionNet(userId);
  if (resp.code != 200) return;
  ctx.dispatch(MainPaoViewActionCreator.attention(userId));
}

//***********************方法***************************** */

/// 关注列表数据
/// stype 0 刷新 1加载
Future<void> watchListData(int stype, Context<MainPaoViewState> ctx) async {
  var resp = await _getWatchListDataNet(0, PAGE_SIZE);
  var type = resp["stype"];
  if (stype == 0) {
    ctx.state.refreshController.refreshCompleted();
  } else {
    ctx.state.refreshController.loadComplete();
  }
  if (type == -1) return;

  /// 帖子列表
  if (type == 0) {
    var list = resp["data"];
    if (stype == 0) {
      ctx.dispatch(MainPaoViewActionCreator.refresh(list));
      return;
    }
    ctx.dispatch(MainPaoViewActionCreator.loadMore(list));
    return;
  }

  /// 贴主列表
  var list = resp["data"];
  if (stype == 0) {
    ctx.dispatch(MainPaoViewActionCreator.userRefresh(list));
    return;
  }
  ctx.dispatch(MainPaoViewActionCreator.userLoadMore(list));
}

//**********************网络********************************** */

/// 获取帖子列表数据
Future _getListDataNet(int skip, int pageSize, int stype) async {
  Map<String, dynamic> args = {"skip": skip, "limit": pageSize};

  var routes = Routers.POSTS_WATCH_LIST;
  if (stype == 1) {
    routes = Routers.POSTS_NEW_LIST;
  } else if (stype == 2) {
    routes = Routers.POSTS_HOT_LIST;
  } else if (stype == 3) {
    routes = Routers.POSTS_REC_LIST;
  }
  var resp = await net.request(routes, args: args);
  return resp;
}

/// 获取关注帖子列表数据
Future _getWatchListDataNet(int skip, int pageSize) async {
  Map<String, dynamic> args = {"skip": skip, "limit": pageSize};

  var respList = await Future.wait([
    net.request(Routers.POSTS_WATCH_LIST, args: args),
    net.request(Routers.USER_REC_WATCH_LIST_GET)
  ]);
  var resp0 = respList[0];
  var resp1 = respList[1];
  var stype = -1;
  if (resp0.code == 200) {
    var list = getPaoDataModelList(resp0.data["posts"]);
    if (list.length > 0) {
      stype = 0;
      return {"stype": stype, "data": list};
    }
  }
  if (resp1.code == 200) {
    var list = getPaoBloggerModelList(resp1.data);
    if (list.length > 0) {
      stype = 1;
      return {"stype": stype, "data": list};
    }
  }

  return {"stype": stype};
}

/// 博主关注数据
Future _sendAttentionNet(int userId) async {
  Map<String, dynamic> args = {"id": userId};

  var routes = Routers.USER_WATCH;

  var resp = await net.request(routes, args: args);
  return resp;
}

/// 取消博主关注数据
// Future _sendCanCelAttentionNet(int userId) async {
//   Map<String, dynamic> args = {"id": userId};

//   var routes = Routers.USER_UNDO_WATCH;

//   var resp = await net.request(routes, args: args);
//   return resp;
// }
