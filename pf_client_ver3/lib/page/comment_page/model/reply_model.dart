import 'package:app/model/user_info_model.dart';

///二级评论列表
class ReplyModel {
  ///评论ID
  int commentId;

  ///帖子id
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

  static ReplyModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ReplyModel commentModelBean = ReplyModel();
    commentModelBean.commentId = map['id'];
    commentModelBean.objectId = map['postId'];
    commentModelBean.parentId = map['topId'];
    commentModelBean.replyId = map['parentId'];
    commentModelBean.userInfo = UserInfoModel.fromMap(map['replyer']);
    commentModelBean.replyUserInfo = UserInfoModel.fromMap(map['bereplyer']);
    commentModelBean.text = map['text'];
    commentModelBean.likeCount = map['likes'];
    commentModelBean.isLike = map['isLike'];
    commentModelBean.createdAt = map['createAt'];
    return commentModelBean;
  }

  static ReplyModel fromLocalMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ReplyModel commentModelBean = ReplyModel();
    commentModelBean.commentId = map['commentId'];
    commentModelBean.objectId = map['objectId'];
    commentModelBean.parentId = map['parentId'];
    commentModelBean.userInfo = UserInfoModel.fromMap(map['userInfo']);
    commentModelBean.replyUserInfo =
        UserInfoModel.fromMap(map['replyUserInfo']);
    commentModelBean.text = map['text'] ?? "";
    commentModelBean.likeCount = map['likeCount'] ?? 0;
    commentModelBean.isLike = map['isLike'] ?? false;
    commentModelBean.createdAt = map['createAt'] ?? "";
    return commentModelBean;
  }

  Map toJson() => {
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
