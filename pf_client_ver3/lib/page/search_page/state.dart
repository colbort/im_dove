import 'package:app/model/search_final_resp.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/page/search_page/av_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'paoba_component/state.dart';

class SearchMainPageState implements Cloneable<SearchMainPageState> {
  //历史查询
  List<String> historyTags = [];
  //热门标签
  List<String> hotTags = [];
  TextEditingController searchController = TextEditingController();
  //刷新组件控制器
  RefreshController refreshController = RefreshController();
  //博主刷新组件控制器
  RefreshController refreshUserController = RefreshController();

  //AV搜索资源
  List<SearchResp> avList = [];
  //泡吧
  List<MainPaoItemState> pbList = [];
  //吧主
  List<Map<String, dynamic>> userList = [];
  //keywords
  String keywords = '';

  //跳过的条数
  int skin = 0;
  int skinUser = 0;
  //查询条数
  int limit = 30;

  //搜索类型  1av  2泡吧
  int type = 1;
  String curSearchWorld = "";
  bool isSearch; //是否搜索
  //是否可以加载更多
  bool canLoad = true;
  int code = 200;
  @override
  SearchMainPageState clone() {
    return SearchMainPageState()
      ..historyTags = historyTags
      ..type = type
      ..hotTags = hotTags
      ..curSearchWorld = curSearchWorld
      ..isSearch = isSearch
      ..avList = avList
      ..pbList = pbList
      ..userList = userList
      ..refreshController = refreshController
      ..keywords = keywords
      ..limit = limit
      ..skin = skin
      ..canLoad = canLoad
      ..searchController = searchController;
  }
}

SearchMainPageState initState(Map<String, dynamic> args) {
  return SearchMainPageState()
    ..historyTags = []
    ..hotTags = []
    ..type = (args != null && args["type"] != null) ? args["type"] : 1
    ..isSearch = false
    ..avList = [];
}

class PaoBaConnector extends ConnOp<SearchMainPageState, PaoBaState> {
  @override
  PaoBaState get(SearchMainPageState state) {
    return PaoBaState()
      ..dataList = state.pbList
      ..userList = state.userList
      ..refreshUserController = state.refreshUserController;
  }

  @override
  void set(SearchMainPageState state, PaoBaState subState) {
    state.pbList = subState.dataList;
    state.userList = subState.userList;
    state.refreshUserController = subState.refreshUserController;
  }
}

class AvConnector extends ConnOp<SearchMainPageState, AvState> {
  @override
  AvState get(SearchMainPageState state) {
    return AvState()..searchResp = state.avList == null ? [] : state.avList;
  }

  @override
  void set(SearchMainPageState state, AvState subState) {
    super.set(state, subState);
    state.avList = subState.searchResp;
  }
}
