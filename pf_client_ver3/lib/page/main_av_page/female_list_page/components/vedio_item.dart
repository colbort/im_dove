import 'package:app/config/colors.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/pojo/video_bean.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/videoPositions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPreview extends StatelessWidget {
  final double width;
  final double height;
  final VideoBean data;
  final bool descriptVisible;
  final bool timeVisible;
  final String domain;
  VideoPreview({
    @required this.width,
    @required this.height,
    this.data,
    this.descriptVisible = true,
    this.timeVisible = false,
    this.domain = 'https://image.kky.mrrwzxk.cn/',
  });

  _buildSign(VideoBean data) {
    final _attr = data.attributes;
    var isVip = _attr?.isVip ?? false;
    bool isPaid = data.isBought;
    if (isVip) {
      return isVipPosition;
    } else if (isPaid) {
      return isPayPosition();
    } else if (!isPaid && _attr.needPay) {
      return isPayPosition(price: _attr.price);
    } else {
      return Container();
    }
  }

  _buildTime(VideoBean data) {
    if (timeVisible && ((data?.playTime ?? '') != '')) {
      return Positioned(
        bottom: 5,
        right: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0x90000000),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            secFmt(data.playTime),
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
                    child: CachedNetworkImage(
                      cacheManager: ImgCacheMgr(),
                      imageUrl: domain + data.coverImg.first,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  ),
                  _buildSign(data),
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
        );
      },
    );
  }
}
