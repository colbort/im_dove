import 'package:app/page/comment_page/custom_comment.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///评论弹窗
void showCommentDialog({
  @required BuildContext context,
  @required int id,
  @required int userId,
  @required int count,
  @required VoidCallback callback,
  Color color,
  double circle,
  double dialogHeight,
}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: color ?? Color(0xefffffff),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(circle ?? Dimens.pt15),
        topRight: Radius.circular(circle ?? Dimens.pt15),
      )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: dialogHeight ?? Dimens.pt780 * 0.55,
          child: CustomCommentWidget(
            commentTotalCount: count,
            objectId: id,
            // userId: userId,
            callback: callback,
          ),
        );
      });
}
