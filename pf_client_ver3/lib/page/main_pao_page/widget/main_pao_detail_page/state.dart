import 'package:app/page/comment_page/custom_comment_short.dart';
import 'package:app/page/comment_page/model/comment_model.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPaoDetailState implements Cloneable<MainPaoDetailState> {
  /// 帖子id
  int postId;

  /// 评论id
  int replyId;

  /// 所属一级评论id 如果点击的是一级评论 topId为0
  int topId;

  PaoDataModel paoDataModel;

  /// 评论数据
  List<CommentModel> commentModelList = [];

  RefreshController refreshController = RefreshController();

  ScrollController scrollController = ScrollController();

  /// 评论控制器 用于回调加载数据 添加一级评论
  CommentController commentController = CommentController();

  bool initedComent = false;
  @override
  MainPaoDetailState clone() {
    return MainPaoDetailState()
      ..postId = postId
      ..replyId = replyId
      ..topId = topId
      ..paoDataModel = paoDataModel
      ..commentModelList = commentModelList
      ..refreshController = refreshController
      ..scrollController = scrollController
      ..initedComent = initedComent
      ..commentController = commentController;
  }
}

MainPaoDetailState initState(Map<String, dynamic> args) {
  return MainPaoDetailState()
    ..postId = args["postId"]
    ..replyId = args["replyId"]
    ..topId = args["topId"];
}
