import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/pojo/video_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPreview extends StatelessWidget {
  final double width;
  final double height;
  final VideoBean data;
  final bool descriptVisible;
  final bool timeVisible;
  final String domain;
  final bool isBig;
  VideoPreview({
    @required this.width,
    @required this.height,
    this.data,
    this.descriptVisible = true,
    this.timeVisible = false,
    this.domain = 'https://image.kky.mrrwzxk.cn/',
    this.isBig = false,
  });

  _buildSign(VideoBean data) {
    if (data == null) {
      return [Container()];
    }
    var isVip = data?.attributes?.isVip ?? false;
    var needPay = data?.attributes?.needPay ?? false;
    var price = data?.attributes?.price ?? '0';
    bool isPaid = data?.isBought ?? false;

    if (isVip) {
      return [
        Positioned(
          left: 0,
          top: 0,
          width: isBig ? 85 : 68,
          height: isBig ? 26 : 20,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
            ),
            child: ImageLoader.withP(
              ImageType.IMAGE_SVG,
              ImgCfg.COMMON_AV_RED,
              fit: BoxFit.cover,
            ).load(),
          ),
        ),
        Positioned(
          left: isBig ? 5 : 3,
          top: isBig ? 2 : 0,
          child: Text(
            Lang.AV_VIP_FREE,
            style: TextStyle(
              fontSize: isBig ? 14 : 12,
              color: c.white,
            ),
          ),
        ),
      ];
    } else if (isPaid) {
      return [
        Positioned(
          left: 0,
          top: 0,
          width: isBig ? 65 : 55,
          height: isBig ? 26 : 20,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
            ),
            child: ImageLoader.withP(
              ImageType.IMAGE_SVG,
              ImgCfg.COMMON_AV_GREEN,
              fit: BoxFit.cover,
            ).load(),
          ),
        ),
        Positioned(
          left: 5,
          top: isBig ? 2 : 0,
          child: Text(
            Lang.AV_ALREADY_PURCHASE,
            style: TextStyle(
              fontSize: isBig ? 14 : 12,
              color: c.white,
            ),
          ),
        ),
      ];
    } else if (needPay && double.tryParse(price) != 0) {
      return [
        Positioned(
          top: 0,
          right: 0,
          width: isBig ? 85 : 65,
          height: isBig ? 26 : 20,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
                child: ImageLoader.withP(
                  ImageType.IMAGE_SVG,
                  ImgCfg.MAIN_BG_VIDEO_BUY,
                  fit: BoxFit.cover,
                ).load(),
              ),
              Container(
                padding: EdgeInsets.only(left: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageLoader.withP(
                      ImageType.IMAGE_SVG,
                      ImgCfg.MAIN_ICON_COIN,
                      fit: BoxFit.fitHeight,
                      height: isBig ? 18 : 14,
                    ).load(),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Text(
                        price,
                        style: TextStyle(
                          fontSize: isBig ? 14 : 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ];
    } else {
      return [Container()];
    }
  }

  _buildTime(VideoBean data) {
    if (timeVisible && ((data?.createdAt ?? '') != '')) {
      return Positioned(
        bottom: 10,
        right: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0x90000000),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            data.createdAt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: c.white,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    var previewUrl = domain + (data?.coverImg?.first ?? '');
    if (previewUrl == domain) {
      previewUrl = '';
    }
    return GestureDetector(
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageLoader.withP(
                      ImageType.IMAGE_NETWORK_HTTP,
                      previewUrl,
                      width: width,
                      height: height,
                    ).load(),
                  ),
                  ..._buildSign(data),
                  _buildTime(data),
                ],
              ),
            ),
            Visibility(
              visible: descriptVisible,
              child: Padding(
                padding: EdgeInsets.only(top: 3, bottom: 5),
                child: Text(
                  data?.title ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: c.c333333,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          'videoPage',
          arguments: {'videoId': data.id},
        ).then((_) {});
      },
    );
  }
}
