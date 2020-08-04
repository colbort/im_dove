import 'package:app/model/search_final_resp.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainAction {
  ///保存搜索记录
  saveHistoryTags,
  //保存热门标签
  saveHotTags,

  ///更新搜索框
  updateSearch,

  /// 清除搜索结果
  clearSearchData,

  /// 搜素数据
  onSearchData,
  searchData,
  //搜索博主
  onSearchUserData,
  searchUserData,

  ///分页加载
  onSearchNextData,
  searchNextData,
  //分页加载博主
  onSearchNextUserData,
  searchNextUserData,

  //修改用户关注状态
  changeUserAttention,

  //搜索博主
  //onSearchUser,

  /// 播放小视频
  //onPlayVideo,

  /// 通知加载数据
  // onNotifyLoadVideoData,

  /// 小视频页面同步数据
  //onAsynVideoData,
}

class MainSearchActionCreator {
  ///保存搜索标签
  static Action saveHistoryTags(List<String> arr) {
    return Action(MainAction.saveHistoryTags, payload: arr);
  }

  ///保存热门标签
  static Action saveHotTags(List<String> arr) {
    return Action(MainAction.saveHotTags, payload: arr);
  }

  ///更新搜索框
  static Action updateSearch(String text) {
    return Action(MainAction.updateSearch, payload: text);
  }

  ///清空搜索框
  static Action clearSearchData() {
    return Action(MainAction.clearSearchData);
  }

  ///搜素数据
  static Action onSearchData(String data) {
    return Action(MainAction.onSearchData, payload: data);
  }

  ///刷新搜索数据
  static Action searchData(List<dynamic> list, String keywords) {
    return Action(MainAction.searchData,
        payload: {'list': list, 'keywords': keywords});
  }

  ///搜素下一页数据
  static Action onSearchNextData() {
    return Action(MainAction.onSearchNextData);
  }

  ///刷新搜索数据状态
  static Action searchNextData(List<SearchResp> list) {
    return Action(MainAction.searchNextData, payload: list);
  }

  ///搜索博主
  static Action onSearchUserData() {
    return Action(MainAction.onSearchUserData);
  }

  ///搜索博主
  static Action searchUserData(List<Map<String, dynamic>> list) {
    return Action(MainAction.searchUserData, payload: list);
  }

  ///加载更多博主
  static Action onSearchNextUserData() {
    return Action(MainAction.onSearchNextUserData);
  }

  static Action searchNextUserData(List<Map<String, dynamic>> list) {
    return Action(MainAction.searchNextUserData, payload: list);
  }

  //修改用户关注状态
  static Action changeUserAttention(int id, bool isAttention) {
    return Action(MainAction.changeUserAttention,
        payload: {"id": id, "isAttention": isAttention});
  }
}
