import 'package:app/model/user_info_model.dart';
import 'package:app/page/comment_page/model/reply_model.dart';

class CommentModel {
  ///评论ID
  int commentId;

  ///帖子ID
  int objectId;

  ///一级评论ID
  int parentId;

  ///回复评论ID
  int replyId;

  ///评论人信息
  UserInfoModel userInfo;

  ///回复人信息
  UserInfoModel replyUserInfo;

  ///评论内容
  String text;

  ///点赞数
  int likeCount;

  ///是否点赞
  bool isLike;

  ///创建时间
  String createdAt;

  ///二级评论列表
  List<ReplyModel> replyList = [];

  bool replyHasNext = false;

  static CommentModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentModel commentModelBean = CommentModel();
    commentModelBean.commentId = map['id'];
    commentModelBean.objectId = map['postId'];
    commentModelBean.parentId = map['topId'];
    commentModelBean.replyId = map['parentId'];
    commentModelBean.userInfo = UserInfoModel.fromMap(map['replyer']);
    commentModelBean.replyUserInfo = UserInfoModel.fromMap(map['bereplyer']);
    commentModelBean.text = map['text'] ?? "";
    commentModelBean.likeCount = map['likes'] ?? 0;
    commentModelBean.isLike = map['isLike'] ?? false;
    commentModelBean.createdAt = map['createAt'] ?? "";
    return commentModelBean;
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "objectId": objectId,
        "parentId": parentId,
        "userInfo": userInfo.toJson(),
        "replyUserInfo": replyUserInfo.toJson(),
        "text": text,
        "likeCount": likeCount,
        "isLike": isLike,
        "createdAt": createdAt,
      };
}

/// 所有一级评论
var firstCommentList = <int>[];
