import 'package:app/page/comment_page/model/reply_model.dart';

class ReplyListRes {
  ///二级评论总条数
  int total;

  ///二级评论列表
  List<ReplyModel> replyList;

  static ReplyListRes fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ReplyListRes commentListRes = ReplyListRes();
    commentListRes.replyList = List()..addAll((map['replys'] as List ?? []).map((o) => ReplyModel.fromMap(o)));
    commentListRes.total = map['total'];
    return commentListRes;
  }

  Map toJson() => {
        "list": replyList,
        "total": total,
      };
}
