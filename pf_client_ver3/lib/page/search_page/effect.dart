import 'dart:math' hide log;
import 'package:app/model/search_final_resp.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/storage/shared_pre_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchMainPageState> buildEffect() {
  return combineEffects(<Object, Effect<SearchMainPageState>>{
    Lifecycle.initState: _init,
    MainAction.onSearchData: _onSearchData,
    MainAction.onSearchNextData: _onSearchNextData,
    MainAction.onSearchUserData: _onSearchUserData,
    MainAction.onSearchNextUserData: _onSearchUserNextData
  });
}

//初始化标签数据
void _init(Action action, Context<SearchMainPageState> ctx) async {
  final ltags = sharedPre.getHistoryTagList();
  final resp =
      await net.request(Routers.HOT_SEARCH, args: {'type': ctx.state.type});

  if (ltags != null) {
    ctx.dispatch(MainSearchActionCreator.saveHistoryTags(ltags));
  }
  if (resp.code == 200) {
    List strs = resp.data[0]['words'].split(',');
    ctx.dispatch(MainSearchActionCreator.saveHotTags(
        strs.sublist(0, min(strs.length, 25))));
  }
}

//搜索数据
void _onSearchData(Action action, Context<SearchMainPageState> ctx) async {
  var map = {
    'keyword': ctx.state.searchController.text,
    'skip': 0,
    'limit': ctx.state.limit
  };
  var rsp;
  if (ctx.state.type == 1)
    rsp = await net.request(Routers.VIDEO_APPSEARCHVIDEO_POST, args: map);
  else
    rsp = await net.request(Routers.VIDEO_PAOBA_SEARCHVIDEO_POST, args: map);

  ctx.state.refreshController.refreshCompleted();

  if (rsp.code == 200) {
    if (ctx.state.type == 1) {
      var sep = SearchFinalResp.fromJson(rsp.data);
      //av
      ctx.dispatch(
          MainSearchActionCreator.searchData(sep.searchResp, action.payload));
    } else {
      //泡吧
      //List list = rsp.data;
      List<MainPaoItemState> pbList = getPaoDataModelListToSearch(rsp.data)
          .map((r) => MainPaoItemState()
            ..bShowUserData = false
            ..paoDataModel = r)
          .toList();

      ctx.dispatch(MainSearchActionCreator.searchData(pbList, action.payload));
    }
  }
}

void _onSearchNextData(Action action, Context<SearchMainPageState> ctx) async {
  var d = await net.request(Routers.VIDEO_APPSEARCHVIDEO_POST, args: {
    'keyword': ctx.state.keywords,
    'skip': ctx.state.avList.length,
    'limit': ctx.state.limit,
  });

  ctx.state.refreshController.loadComplete();
  if (d.code == 200) {
    var d1 = SearchFinalResp.fromJson(d.data);
    if (ctx.state.type == 1) {
      //av
      ctx.dispatch(MainSearchActionCreator.searchNextData(d1.searchResp));
    } else {
      //泡吧
      //  ctx.dispatch(MainSearchActionCreator.updateSearch('d1'));
    }
  }
  // ctx.dispatch(MainSearchActionCreator.searchData());
}

void _onSearchUserData(Action action, Context<SearchMainPageState> ctx) async {
  var map = {
    'keyword': ctx.state.searchController.text,
    'skip': 0,
    'limit': ctx.state.limit
  };
  var rsp =
      await net.request(Routers.VIDEO_PAOBA_USER_SEARCHVIDEO_POST, args: map);
  ctx.state.refreshUserController.refreshCompleted();
  if (rsp.code == 200) {
    List<dynamic> list = rsp.data;

    ctx.dispatch(MainSearchActionCreator.searchUserData(list.map((f) {
      Map<String, dynamic> m = Map();
      m['id'] = f['id'];
      m['nickName'] = f['nickName'];
      m['logo'] = f['logo'];
      m['attention'] = f['attention'];
      return m;
    }).toList()));
  }
}

void _onSearchUserNextData(
    Action action, Context<SearchMainPageState> ctx) async {
  var map = {
    'keyword': ctx.state.searchController.text,
    'skip': ctx.state.userList.length,
    'limit': ctx.state.limit
  };
  var rsp =
      await net.request(Routers.VIDEO_PAOBA_USER_SEARCHVIDEO_POST, args: map);
  ctx.state.refreshUserController.loadComplete();
  if (rsp.code == 200) {
    List<dynamic> list = rsp.data;

    ctx.dispatch(MainSearchActionCreator.searchNextUserData(list.map((f) {
      Map<String, dynamic> m = Map();
      m['id'] = f['id'];
      m['nickName'] = f['nickName'];
      m['logo'] = f['logo'];
      m['attention'] = f['attention'];
      return m;
    }).toList()));
  }
}
