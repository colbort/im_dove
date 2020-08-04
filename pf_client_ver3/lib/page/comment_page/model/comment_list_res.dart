import 'package:app/page/comment_page/model/comment_model.dart';

///评论列表
class CommentListRes {
  ///一级评论总条数
  int total;

  ///一级评论列表
  List<CommentModel> commentList;

  static CommentListRes fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentListRes commentListRes = CommentListRes();
    commentListRes.commentList = List()
      ..addAll(
          (map['replys'] as List ?? []).map((o) => CommentModel.fromMap(o)));
    commentListRes.total = map['total'];
    return commentListRes;
  }

  static CommentListRes quickFromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentListRes commentListRes = CommentListRes();
    commentListRes.commentList = List()
      ..addAll(
          (map['replys'] as List ?? []).map((o) => CommentModel.fromMap(o)));
    commentListRes.total = map['top_total'];
    return commentListRes;
  }

  Map toJson() => {
        "list": commentList,
        "total": total,
      };
}
