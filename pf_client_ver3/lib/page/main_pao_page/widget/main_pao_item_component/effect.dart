import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/comment_page/entry/comment_entry.dart';
import 'package:app/page/wallet_page/effect.dart';
import 'package:app/widget/common/toast/src/core/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoItemState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoItemState>>{
    // MainPaoItemAction.action: _onAction,
    MainPaoItemAction.onAttention: _onAttention,
    MainPaoItemAction.onCollect: _onCollect,
    MainPaoItemAction.onLike: _onLike,
    MainPaoItemAction.onComment: _onComment,
    MainPaoItemAction.onOpenUserData: _onOpenUserData,
    MainPaoItemAction.onDelPost: _onDelPost,
    MainPaoItemAction.onBuyPost: _onBuyPost,
  });
}

// void _onAction(Action action, Context<MainPaoItemState> ctx) {}

Future<void> _onBuyPost(Action action, Context<MainPaoItemState> ctx) async {
  var no = action.payload;
  var resp = await sendBuyVideotNet(no);
  if (resp.code != Code.SUCCESS) {
    showToast(resp.msg());
    return;
  }
  ctx.dispatch(MainPaoItemActionCreator.buyPost(no));
  sendWalletNet();
}

/// 关注
Future<void> _onAttention(Action action, Context<MainPaoItemState> ctx) async {
  var bAttention = !ctx.state.paoDataModel.bAttention;
  ctx.dispatch(MainPaoItemActionCreator.attention(ctx.state.paoDataModel.no));
  if (bAttention) {
    var resp = await sendAttentionNet(ctx.state.paoDataModel.userId);
    if (resp.code != 200) return;
    showToast(Lang.GUANZHUSUCC);
  } else {
    var resp = await sendCancelAttentionNet(ctx.state.paoDataModel.userId);
    if (resp.code != 200) return;
    showToast(Lang.QUXIAOGUANZHU);
  }
}

/// 收藏
Future<void> _onCollect(Action action, Context<MainPaoItemState> ctx) async {
  var isCollect = !ctx.state.paoDataModel.isCollect;
  ctx.dispatch(MainPaoItemActionCreator.collect(ctx.state.paoDataModel.no));
  if (isCollect) {
    var resp = await sendCollectNet(ctx.state.paoDataModel.no);
    if (resp.code != 200) return;
    showToast(Lang.SHOUCANGSUCC);
    // ctx.state.paoDataModel.totalCollect = resp.data["count"] as int;
  } else {
    var resp = await sendCancelCollectNet(ctx.state.paoDataModel.no);
    if (resp.code != 200) return;
    showToast(Lang.QUXIAOSHOUCANG);
    // ctx.state.paoDataModel.totalCollect = resp.data["count"] as int;
  }
}

/// 点赞
Future<void> _onLike(Action action, Context<MainPaoItemState> ctx) async {
  var isLike = !ctx.state.paoDataModel.isLike;
  ctx.dispatch(MainPaoItemActionCreator.like(ctx.state.paoDataModel.no));
  if (isLike) {
    var resp = await sendLikeNet(ctx.state.paoDataModel.no);
    if (resp.code != 200) return;
    showToast(Lang.DIANZANSUCC);
    // ctx.state.paoDataModel.totalLike = resp.data["count"] as int;
  } else {
    var resp = await sendCancelLiketNet(ctx.state.paoDataModel.no);
    if (resp.code != 200) return;
    showToast(Lang.QUXIAODIANZAN);
    // ctx.state.paoDataModel.totalLike = resp.data["count"] as int;
  }
}

/// 评论
Future<void> _onComment(Action action, Context<MainPaoItemState> ctx) async {
  showCommentDialog(
    context: ctx.context,
    id: ctx.state.paoDataModel.no,
    count: ctx.state.paoDataModel.totalComment,
    userId: ctx.state.paoDataModel.userId,
    callback: () {
      ctx.dispatch(MainPaoItemActionCreator.changeTotalComent(
          ctx.state.paoDataModel.no));
    },
  );
  // Navigator.of(ctx.context).pushNamed(page_noticeList)
}

void _onOpenUserData(Action action, Context<MainPaoItemState> ctx) {
  var bSelf = false;
  if (bSelf) return;

  /// 他人的界面
  // Navigator.of(ctx.context).pushNamed(page_noticeList)
}

/// 删除评论
Future<void> _onDelPost(Action action, Context<MainPaoItemState> ctx) async {
  int no = action.payload;
  var resp = await sendDelPosttNet(no);
  if (resp.code != 200) return;
}

//******************网络******************************** */

/// 关注
/// userId 用户id
Future sendAttentionNet(int userId) async {
  Map<String, dynamic> args = {"id": userId};
  var resp = await net.request(Routers.USER_WATCH, args: args);
  return resp;
}

/// 取消关注
/// userId 用户id
Future sendCancelAttentionNet(int userId) async {
  Map<String, dynamic> args = {"id": userId};
  var resp = await net.request(Routers.USER_UNDO_WATCH, args: args);
  return resp;
}

/// 收藏
/// id:帖子id
Future sendCollectNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_FAV, args: args);
  return resp;
}

/// 取消收藏
/// id:帖子id
Future sendCancelCollectNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_UNDO_FAV, args: args);
  return resp;
}

/// 点赞
/// id:帖子id
Future sendLikeNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_LIKE, args: args);
  return resp;
}

/// 取消点赞
/// id:帖子id
Future sendCancelLiketNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_UNDO_LIKE, args: args);
  return resp;
}

/// 删除帖子
/// id:帖子id
Future sendDelPosttNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_DELETE_POST, args: args);
  return resp;
}

/// 购买帖子
/// id:帖子id
Future sendBuyVideotNet(int id) async {
  Map<String, dynamic> args = {"id": id};
  var resp = await net.request(Routers.POSTS_BUY_POST, args: args);
  return resp;
}
