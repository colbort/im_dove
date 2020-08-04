import 'package:app/config/colors.dart';
import 'package:app/config/text_style.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/material.dart';

/// 背景颜色
final List<Color> _bgColors = [
  c.cFFDEDE, // 粉色
  c.cDEF0FD, // 蓝色
];

/// 文字颜色
final List<Color> _textColors = [
  c.cFF7676, // 粉红
  c.c58B4F4, // 深蓝
];

/// 多彩的label组件
class LabelWidget extends StatelessWidget {
  final String text;
  final int index;
  const LabelWidget(this.text, {Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: Dimens.pt4),
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.pt6, vertical: Dimens.pt3),
      decoration: BoxDecoration(
        color: _bgColors[index % 2],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: t.fontSize13,
          height: 15 / 12,
          fontWeight: FontWeight.w400,
          color: _textColors[index % 2],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
