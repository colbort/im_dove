import 'package:flutter/material.dart';
import 'package:app/utils/screen.dart';

import 'baseItem.dart';

/// item 宽
final iw = s.realW(178);

/// item 高
final ih = s.realH(166);

/// 图片高
final ph = s.realH(118);

/// 文字高
final th = s.realH(40);

/// 主要用于： [首页cell] [AV cell] 等;
/// [imgurl]: 视频封面图片  [timeLong]: 播放时长  [title]: 视频标题 [actors]: 演员名称
///
Widget gridItem({
  String title,
  int watchTimes,
  String imgUrl,
  int timeLong,
  String actors,
  Function tapVideo,
  bool isVipVideo,
  bool isBuyVideo,
}) {
  return Container(
    width: (iw),
    height: (ih),
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        buildBaseVedioItem(
          watchTimes: watchTimes,
          imgUrl: imgUrl,
          timeLong: timeLong,
          actors: actors,
          tapVideo: tapVideo,
          isVipVideo: isVipVideo,
          isBuyVideo: isBuyVideo,
        ),
        // //描述
        Container(
          //遮罩
          width: (iw),
          height: th,
          padding: EdgeInsets.only(left: 4.0, top: 0),
          alignment: Alignment.topLeft,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Color(0xff363636), fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
