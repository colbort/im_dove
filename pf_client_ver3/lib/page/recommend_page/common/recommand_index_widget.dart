import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/config/text_style.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/material.dart';

/// 推荐指数控件
class RecommendIndexWidget extends StatelessWidget {
  // 推荐指数1-5颗星
  final int index;
  const RecommendIndexWidget({Key key, int index = 0})
      : this.index = index ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          /// 推荐指数
          Container(
            margin: EdgeInsets.only(right: Dimens.pt2),
            child: Text(
              Lang.TUIJIANZXHISHU_TIP,
              style: TextStyle(
                  fontSize: t.fontSize14, height: 20 / 14, color: c.c979797),
              textAlign: TextAlign.left,
            ),
          ),

          /// 图片
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Positioned(
                child: Container(
                  height: Dimens.pt20,
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    ImgCfg.COMMON_XIN_unselect,
                    width: Dimens.pt104,
                    height: Dimens.pt12,
                    repeat: ImageRepeat.repeatX,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),

              /// 图片
              Container(
                height: Dimens.pt20,
                child: Image.asset(
                  ImgCfg.COMMON_XIN_select,
                  width: Dimens.pt20 * index / 2,
                  height: Dimens.pt12,
                  fit: index / 2 < 1 ? BoxFit.cover : BoxFit.contain,
                  repeat: ImageRepeat.repeatX,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
