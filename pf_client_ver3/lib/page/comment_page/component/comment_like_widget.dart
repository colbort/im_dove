import 'package:app/config/image_cfg.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///点赞或取消点赞回调
typedef LikeCallback = Function(bool isLike);

///点赞 widget
class LikeWidget extends StatefulWidget {
  //图片宽
  final double width;

  // 图片高
  final double height;

  final bool isLike;

  final LikeCallback callback;

  final EdgeInsets padding;

  final int likeCount;

  LikeWidget(
      {Key key,
      this.isLike = false,
      this.width,
      this.height,
      this.callback,
      this.padding,
      this.likeCount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LikeWidgetState();
  }
}

class _LikeWidgetState extends State<LikeWidget> {
  bool isLike;

  int likeCount;

  @override
  void initState() {
    super.initState();
    isLike = widget.isLike;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLike = !isLike;
          if (isLike) {
            ++likeCount;
          } else {
            --likeCount;
          }
          if (widget.callback != null) widget.callback(isLike);
        });
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(Dimens.pt5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              isLike ?? false ? ImgCfg.LIKE_SELECTED : ImgCfg.LIKE_NORMAL,
              width: widget.width ?? Dimens.pt20,
              height: widget.height ?? Dimens.pt20,
            ),
            Padding(
              padding: EdgeInsets.only(top: Dimens.pt2),
            ),
            Text("${numCoverStr(likeCount)}",
                style: TextStyle(color: Colors.grey, fontSize: Dimens.pt10))
          ],
        ),
      ),
    );
  }
}
