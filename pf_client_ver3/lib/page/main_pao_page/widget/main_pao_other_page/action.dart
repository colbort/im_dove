import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainPaoOtherAction {
  action,
  getUserdata,

  /// 我的帖子加载更多
  onMyPostLoadMore,

  /// 我的帖子加载更多
  myPostLoadMore,

  /// 我的帖子刷新
  onMyPostRefresh,

  /// 我的帖子刷新
  myPostRefresh,

  /// 我的评论加载更多
  onMyRePlysLoadMore,

  /// 我的评论加载更多
  myRePlysLoadMore,

  /// 我的评论刷新
  onMyRePlysRefresh,

  /// 我的评论刷新
  myRePlysRefresh,

  /// 我的收藏购买加载更多
  onMyFav2BuyLoadMore,

  /// 我的收藏购买加载更多
  myFav2BuyLoadMore,

  /// 我的收藏购买刷新
  onMyFav2BuyRefresh,

  /// 我的收藏购买刷新
  myFav2BuyRefresh,
}

class MainPaoOtherActionCreator {
  static Action onAction() {
    return const Action(MainPaoOtherAction.action);
  }

  /// 获取用户数据
  static Action getUserdata(PaoUserDataModel data) {
    return Action(MainPaoOtherAction.getUserdata, payload: data);
  }

  /// 我的帖子加载更多
  static Action onMyPostLoadMore() {
    return const Action(MainPaoOtherAction.onMyPostLoadMore);
  }

  /// 我的帖子加载更多
  static Action myPostLoadMore(List<PaoDataModel> data) {
    return Action(MainPaoOtherAction.myPostLoadMore, payload: data);
  }

  /// 我的帖子刷新
  static Action onMyPostRefresh() {
    return const Action(MainPaoOtherAction.onMyPostRefresh);
  }

  /// 我的帖子刷新
  static Action myPostRefresh(List<PaoDataModel> data) {
    return Action(MainPaoOtherAction.myPostRefresh, payload: data);
  }

  /// 我的评论加载更多
  static Action onMyRePlysLoadMore() {
    return const Action(MainPaoOtherAction.onMyRePlysLoadMore);
  }

  /// 我的评论加载更多
  static Action myRePlysLoadMore(List<PaoCommentModel> data) {
    return Action(MainPaoOtherAction.myRePlysLoadMore, payload: data);
  }

  /// 我的评论刷新
  static Action onMyRePlysRefresh() {
    return const Action(MainPaoOtherAction.onMyRePlysRefresh);
  }

  /// 我的评论刷新
  static Action myRePlysRefresh(List<PaoCommentModel> data) {
    return Action(MainPaoOtherAction.myRePlysRefresh, payload: data);
  }

  /// 我的收藏购买加载更多
  static Action onMyFav2BuyLoadMore() {
    return const Action(MainPaoOtherAction.onMyFav2BuyLoadMore);
  }

  /// 我的收藏购买加载更多
  static Action myFav2BuyLoadMore(List<PaoDataModel> data) {
    return Action(MainPaoOtherAction.myFav2BuyLoadMore, payload: data);
  }

  /// 我的收藏购买刷新
  static Action onMyFav2BuyRefresh() {
    return const Action(MainPaoOtherAction.onMyFav2BuyRefresh);
  }

  /// 我的收藏购买刷新
  static Action myFav2BuyRefresh(List<PaoDataModel> data) {
    return Action(MainPaoOtherAction.myFav2BuyRefresh, payload: data);
  }
}
