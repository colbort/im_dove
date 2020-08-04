// import 'package:connectivity/connectivity.dart';
import 'package:app/model/search_final_resp.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchMainPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchMainPageState>>{
      MainAction.saveHistoryTags: _saveHistoryTags,
      MainAction.saveHotTags: _saveHotTags,
      MainAction.searchData: _searchData,
      MainAction.searchNextData: _searchNextData,
      MainAction.searchUserData: _searchUserData,
      MainAction.searchNextUserData: _searchNextUserData,
      MainAction.updateSearch: _updateSearch,
      MainAction.clearSearchData: _clearSearchData,
      MainAction.changeUserAttention: _changeUserAttention
    },
  );
}

SearchMainPageState _saveHistoryTags(SearchMainPageState state, Action action) {
  final SearchMainPageState newState = state.clone();
  newState.historyTags = action.payload;
  return newState;
}

SearchMainPageState _saveHotTags(SearchMainPageState state, Action action) {
  final SearchMainPageState newState = state.clone();
  newState.hotTags = action.payload;
  return newState;
}

SearchMainPageState _updateSearch(SearchMainPageState state, Action action) {
  final SearchMainPageState newState = state.clone();

  if (action.payload == '') newState.isSearch = false;
  return newState;
}

SearchMainPageState _clearSearchData(SearchMainPageState state, Action action) {
  final SearchMainPageState newState = state.clone();
  newState.isSearch = false;
  newState.keywords = '';
  return newState;
}

SearchMainPageState _searchData(SearchMainPageState state, Action action) {
  final SearchMainPageState newState = state.clone();
  newState.isSearch = true;
  if (action.payload['list'].length < newState.limit)
    newState.refreshController.loadNoData();

  if (newState.type == 1)
    newState.avList = action.payload['list'];
  else
    newState.pbList = action.payload['list'];

  newState.keywords = action.payload['keywords'];

  return newState;
}

SearchMainPageState _searchNextData(SearchMainPageState state, Action action) {
  List<SearchResp> searchResp = action.payload;

  final SearchMainPageState newState = state.clone();
  if (searchResp.length < state.limit)
    newState.refreshController.loadNoData();
  else {
    if (newState.type == 1)
      newState.avList.addAll(searchResp);
    else
      newState.avList.addAll(searchResp);
  }

  return newState;
}

SearchMainPageState _searchUserData(SearchMainPageState state, Action action) {
  if (action.payload == null) {
    return state;
  }

  final SearchMainPageState newState = state.clone();
  newState.userList = action.payload;
  newState.isSearch = true;
  return newState;
}

SearchMainPageState _searchNextUserData(
    SearchMainPageState state, Action action) {
  if (action.payload == null) {
    return state;
  }

  final SearchMainPageState newState = state.clone();
  newState.userList.addAll(action.payload);
  return newState;
}

SearchMainPageState _changeUserAttention(
    SearchMainPageState state, Action action) {
  int id = action.payload['id'];
  bool isAttention = action.payload['isAttention'];

  final SearchMainPageState newState = state.clone();

  for (var user in newState.userList) {
    if (user['id'] == id) {
      user['attention'] = isAttention;
    }
  }
  return newState;
}
