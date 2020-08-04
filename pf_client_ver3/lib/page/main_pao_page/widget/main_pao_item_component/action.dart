import 'package:fish_redux/fish_redux.dart';

enum MainPaoItemAction {
  // action,

  /// 关注
  onAttention,

  /// 关注
  attention,

  /// 展开
  expand,

  /// 收藏
  onCollect,

  /// 收藏
  collect,

  /// 点赞
  onLike,

  /// 点赞
  like,

  /// 评论
  onComment,

  /// 打开用户数据
  onOpenUserData,

  /// 删除帖子
  onDelPost,

  ///  删除帖子
  delPost,

  /// 修改评论数量
  changeTotalComent,

  /// 购买视频
  onBuyPost,

  /// 购买视频
  buyPost,
}

class MainPaoItemActionCreator {
  // static Action onAction() {
  //   return const Action(MainPaoItemAction.action);
  // }

  /// 购买视频
  /// 帖子id
  static Action onBuyPost(int id) {
    return Action(MainPaoItemAction.onBuyPost, payload: id);
  }

  /// 购买视频
  /// 帖子id
  static Action buyPost(int id) {
    return Action(MainPaoItemAction.buyPost, payload: id);
  }

  /// 关注
  static Action onAttention(int id) {
    return Action(MainPaoItemAction.onAttention, payload: id);
  }

  /// 关注
  static Action attention(int id) {
    return Action(MainPaoItemAction.attention, payload: id);
  }

  /// 展开
  static Action expand(int id) {
    return Action(MainPaoItemAction.expand, payload: id);
  }

  /// 收藏
  static Action onCollect(int id) {
    return Action(MainPaoItemAction.onCollect, payload: id);
  }

  /// 收藏
  static Action collect(int id) {
    return Action(MainPaoItemAction.collect, payload: id);
  }

  /// 点赞
  static Action onLike(int id) {
    return Action(MainPaoItemAction.onLike, payload: id);
  }

  /// 点赞
  static Action like(int id) {
    return Action(MainPaoItemAction.like, payload: id);
  }

  /// 评论
  static Action onComment(int id) {
    return Action(MainPaoItemAction.onComment, payload: id);
  }

  static Action onOpenUserData() {
    return const Action(MainPaoItemAction.onOpenUserData);
  }

  static Action onDelPost(int id) {
    return Action(MainPaoItemAction.onDelPost, payload: id);
  }

  static Action delPost(int id) {
    return Action(MainPaoItemAction.delPost, payload: id);
  }

  static Action changeTotalComent(int id) {
    return Action(MainPaoItemAction.changeTotalComent, payload: id);
  }
}
