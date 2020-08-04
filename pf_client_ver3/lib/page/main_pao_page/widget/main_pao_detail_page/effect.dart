import 'package:app/net/net.dart';
import 'package:app/page/comment_page/model/comment_list_res.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/utils/dur.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoDetailState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoDetailState>>{
    // MainPaoDetailAction.action: _onAction,
    MainPaoDetailAction.onRefresh: _onRefresh,
    Lifecycle.initState: _initState,
  });
}

// void _onAction(Action action, Context<MainPaoDetailState> ctx) {}
Future<void> _initState(Action action, Context<MainPaoDetailState> ctx) async {
  var postId = ctx.state.postId;
  var replyId = ctx.state.replyId;
  var topId = ctx.state.topId;
  var resp0 = await sendPostNet(postId);
  if (resp0.code == Code.SUCCESS) {
    var data = PaoDataModel.fromJson(resp0.data["post"]);
    ctx.dispatch(MainPaoDetailActionCreator.postRefresh(data));
  }
  var resp1 = await sendCommentListnNet(postId, replyId, topId);
  ctx.state.refreshController.refreshCompleted();
  if (resp1.code == Code.SUCCESS) {
    var data = CommentListRes.quickFromMap(resp1.data);
    ctx.dispatch(MainPaoDetailActionCreator.commoentRefresh(data.commentList));
    Future.delayed(dur100, () {
      ctx.state.scrollController.animateTo(
          ctx.state.scrollController.position.maxScrollExtent,
          duration: dur100,
          curve: curDef);
    });
  }
}

Future<void> _onRefresh(Action action, Context<MainPaoDetailState> ctx) async {
  var postId = ctx.state.postId;
  var replyId = ctx.state.replyId;
  var topId = ctx.state.topId;
  var resp0 = await sendPostNet(postId);
  if (resp0.code == Code.SUCCESS) {
    var data = PaoDataModel.fromJson(resp0.data["post"]);
    ctx.dispatch(MainPaoDetailActionCreator.postRefresh(data));
  }
  var resp1 = await sendCommentListnNet(postId, replyId, topId);
  ctx.state.refreshController.refreshCompleted();
  if (resp1.code == Code.SUCCESS) {
    var data = CommentListRes.quickFromMap(resp1.data);
    ctx.dispatch(MainPaoDetailActionCreator.commoentRefresh(data.commentList));

    // ctx.state.scrollController
    //     .jumpTo(ctx.state.scrollController.position.maxScrollExtent);

    // Future.delayed(dur100, () async {
    //   // ctx.state.scrollController.animateTo(
    //   //     ctx.state.scrollController.position.maxScrollExtent,
    //   //     duration: dur100,
    //   //     curve: curDef);
    //   // await ctx.state.commentScrollController.position.moveTo(
    //   //     ctx.state.commentScrollController.position.maxScrollExtent,
    //   //     duration: dur100,
    //   //     curve: curDef);
    //   ctx.dispatch(MainPaoDetailActionCreator.changeInitedComment());
    // });
  }
}

//******************网络******************************** */

/// 获取评论数据
/// postId 帖子Id
/// replyId 当前点击的评论Id
/// topId 所属一级评论Id
Future sendCommentListnNet(int postId, int replyId, int topId) async {
  Map<String, dynamic> args = {
    "postId": postId,
    "replyId": replyId,
    "topId": topId,
  };
  var resp = await net.request(Routers.POSTS_QUICK_REPLYS_POST, args: args);
  return resp;
}

/// 获取单个帖子数据
/// postId 帖子Id
Future sendPostNet(int postId) async {
  Map<String, dynamic> args = {
    "id": postId,
  };
  var resp = await net.request(Routers.POSTS_GET_POST, args: args);
  return resp;
}
