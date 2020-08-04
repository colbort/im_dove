import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainPaoMineAction {
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

  /// 更新签名
  onUpdateSign,

  /// 更新签名
  updateSign,

  /// 更新封面
  onUpdateUserBgImg,

  /// 更新封面
  updateUserBgImg,
}

class MainPaoMineActionCreator {
  // static Action onAction() {
  //   return const Action(MainPaoMineAction.action);
  // }

  /// 获取用户数据
  static Action getUserdata(PaoUserDataModel data) {
    return Action(MainPaoMineAction.getUserdata, payload: data);
  }

  /// 我的帖子加载更多
  static Action onMyPostLoadMore() {
    return const Action(MainPaoMineAction.onMyPostLoadMore);
  }

  /// 我的帖子加载更多
  static Action myPostLoadMore(List<PaoDataModel> data) {
    return Action(MainPaoMineAction.myPostLoadMore, payload: data);
  }

  /// 我的帖子刷新
  static Action onMyPostRefresh() {
    return const Action(MainPaoMineAction.onMyPostRefresh);
  }

  /// 我的帖子刷新
  static Action myPostRefresh(List<PaoDataModel> data) {
    return Action(MainPaoMineAction.myPostRefresh, payload: data);
  }

  /// 我的评论加载更多
  static Action onMyRePlysLoadMore() {
    return const Action(MainPaoMineAction.onMyRePlysLoadMore);
  }

  /// 我的评论加载更多
  static Action myRePlysLoadMore(List<PaoCommentModel> data) {
    return Action(MainPaoMineAction.myRePlysLoadMore, payload: data);
  }

  /// 我的评论刷新
  static Action onMyRePlysRefresh() {
    return const Action(MainPaoMineAction.onMyRePlysRefresh);
  }

  /// 我的评论刷新
  static Action myRePlysRefresh(List<PaoCommentModel> data) {
    return Action(MainPaoMineAction.myRePlysRefresh, payload: data);
  }

  /// 我的收藏购买加载更多
  static Action onMyFav2BuyLoadMore() {
    return const Action(MainPaoMineAction.onMyFav2BuyLoadMore);
  }

  /// 我的收藏购买加载更多
  static Action myFav2BuyLoadMore(List<PaoDataModel> data) {
    return Action(MainPaoMineAction.myFav2BuyLoadMore, payload: data);
  }

  /// 我的收藏购买刷新
  static Action onMyFav2BuyRefresh() {
    return const Action(MainPaoMineAction.onMyFav2BuyRefresh);
  }

  /// 我的收藏购买刷新
  static Action myFav2BuyRefresh(List<PaoDataModel> data) {
    return Action(MainPaoMineAction.myFav2BuyRefresh, payload: data);
  }

  static Action onUpdateSign(String text) {
    return Action(MainPaoMineAction.onUpdateSign, payload: text);
  }

  static Action updateSign(String text) {
    return Action(MainPaoMineAction.updateSign, payload: text);
  }

  /// 更新封面
  static Action onUpdateUserBgImg(String data) {
    return Action(MainPaoMineAction.onUpdateUserBgImg, payload: data);
  }

  /// 更新封面
  static Action updateUserBgImg(String data) {
    return Action(MainPaoMineAction.updateUserBgImg, payload: data);
  }
}
