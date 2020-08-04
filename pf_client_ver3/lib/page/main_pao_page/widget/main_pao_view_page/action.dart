import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainPaoViewAction {
  // action,

  /// 加载
  onLoadMore,

  /// 加载更多
  loadMore,

  /// 刷新
  onRefresh,

  /// 刷新
  refresh,

  /// 博主 关注
  onAttention,

  /// 博主 关注
  attention,

  /// 帖主加载更多
  userLoadMore,

  /// 帖主刷新
  userRefresh,
}

class MainPaoViewActionCreator {
  // static Action onAction() {
  //   return const Action(MainPaoViewAction.action);
  //
  // static Action onInitData(int index) {
  //   return Action(MainPaoViewAction.onInitData, payload: index);
  // }

  static Action onLoadMore() {
    return const Action(MainPaoViewAction.onLoadMore);
  }

  static Action loadMore(List<PaoDataModel> data) {
    return Action(MainPaoViewAction.loadMore, payload: data);
  }

  static Action onRefresh() {
    return const Action(MainPaoViewAction.onRefresh);
  }

  static Action refresh(List<PaoDataModel> data) {
    return Action(MainPaoViewAction.refresh, payload: data);
  }

  static Action onAttention(int userId) {
    return Action(MainPaoViewAction.onAttention, payload: userId);
  }

  static Action attention(int userId) {
    return Action(MainPaoViewAction.attention, payload: userId);
  }

  static Action userLoadMore(List<PaoDataModel> data) {
    return Action(MainPaoViewAction.userLoadMore, payload: data);
  }

  static Action userRefresh(List<PaoBloggerModel> data) {
    return Action(MainPaoViewAction.userRefresh, payload: data);
  }
}
