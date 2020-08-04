import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

import 'baseItem.dart';

/// item 宽
final iw5 = s.realW(5);

///
final iw = s.realW(178);

/// item 高
final ih = s.realH(166);

/// 图片高
final ph = s.realH(118);

/// 文字高
final th = s.realH(40);

/// 文字高
final th12 = s.realH(12);
final th18 = s.realH(18);

final th25 = s.realH(25);

/// 主要用于： [视频播放页 > 猜你喜欢列表] [搜索结果页] 等;
/// [imgurl]: 视频封面图片  [timeLong]: 播放时长  [title]: 视频标题 [actors]: 演员名称
Widget vedioRowItem({
  String imgUrl,
  int timeLong,
  String title = '',
  String actors,
  Function tapVideo,
  List tags = const [],
  int watchTimes = 0,
  isVipVideo = false,
  isPayVideo,
  isPayed,
  price,
}) {
  var _tags = tags.length > 3 ? tags.sublist(0, 3) : tags;

  Widget _buildTag(String name) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 6, bottom: 6),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(247, 211, 91, 0.5)),
        child: Text(
          name,
          style: TextStyle(fontSize: th12),
        ),
      ),
    );
  }

  return Row(
    children: <Widget>[
      buildBaseVedioItem(
        imgUrl: imgUrl,
        tapVideo: tapVideo,
        timeLong: timeLong,
        watchTimes: watchTimes,
        actors: actors,
        isVipVideo: isVipVideo,
        isPayVideo: isPayVideo,
        isPayed: isPayed,
        price: price,
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: iw5),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xff363636), fontSize: th12),
                ),
              ),
              tags != null
                  ? Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          ..._tags.map((f) => _buildTag(f)).toList()
                        ],
                      ),
                    )
                  : Container(),
              // Container(
              //   child: Text(
              //       watchTimes < 10000
              //           ? '$watchTimes次观看'
              //           : '${watchTimes / 10000}万次观看',
              //       style: TextStyle(color: Color(0xff010001), fontSize: th12)),
              // )
            ],
          ),
        ),
      )
    ],
  );
}
