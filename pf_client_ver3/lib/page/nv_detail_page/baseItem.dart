import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

///
final iw = s.realW(178);
final ph = s.realH(118);
final th25 = s.realH(25);
final th12 = s.realH(12);

/// item 高
final ih = s.realH(166);
Widget buildBaseVedioItem({
  String imgUrl,
  Function tapVideo,
  int timeLong,
  String actors,
  int watchTimes,
  bool isVipVideo,
  bool isBuyVideo = false,
}) {
  return Container(
    width: (iw),
    height: (ph),
    child: Stack(
      children: <Widget>[
        //图片
        Positioned(
          top: 0,
          child: GestureDetector(
            child: Container(
              child: CachedNetworkImage(
                cacheManager: ImgCacheMgr(),
                imageUrl: imgUrl,
                width: (iw),
                height: (ph),
                fit: BoxFit.cover,
              ),
            ),
            onTap: tapVideo, //点击
          ),
        ),
        //背景
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(0, 0, 0, 0),
                Color.fromARGB(128, 0, 0, 0)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            width: (iw),
            height: th25,
          ),
        ),
        Positioned(
          bottom: 6,
          left: 6,
          child: Text(
              watchTimes < 10000
                  ? '$watchTimes次观看'
                  : '${(watchTimes / 10000).toStringAsFixed(1)}万次观看',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        //角色名称
        Positioned(
            bottom: 5,
            right: 6,
            child: Text(actors != null ? "$actors" : '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12))),
        isVipVideo ? vipIcon() : Container(),
        isBuyVideo ? buyIcon() : Container(),
      ],
    ),
  );
}

//MARK:--vip 视频左上角小标
Widget vipIcon({bool homePage}) {
  return Positioned(
    child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
        child: Container(
          width: homePage != null ? 58 : 35,
          height: homePage != null ? 33.4 : 18,
          color: const Color(0Xffd0b77e),
          alignment: Alignment.center,
          child: Text(
            'VIP',
            style: TextStyle(
                color: Colors.white, fontSize: homePage != null ? 14 : 12),
          ),
        )),
  );
}

//MARK:--首页付费 视频左上角小标
Widget buyIcon({bool homePage}) {
  return Positioned(
    child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
        child: Container(
          width: homePage != null ? 58 : 35,
          height: homePage != null ? 33.4 : 18,
          color: const Color(0Xffd0b77e),
          alignment: Alignment.center,
          child: Text(
            Lang.BUY,
            style: TextStyle(
                color: Colors.white, fontSize: homePage != null ? 14 : 12),
          ),
        )),
  );
}
