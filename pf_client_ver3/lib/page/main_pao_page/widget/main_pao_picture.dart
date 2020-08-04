import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'main_pao_video.dart';

/// 图片 九宫布局
class MainPaoPicture extends StatefulWidget {
  final List<String> picList;
  final PaoDataModel data;
  final Function onOptCallbackFn;

  const MainPaoPicture({
    @required this.picList,
    @required this.data,
    this.onOptCallbackFn,
  });

  @override
  MainPaoPicturetate createState() => MainPaoPicturetate();
}

class MainPaoPicturetate extends State<MainPaoPicture> {
  double w = 0;
  double h = 0;
  int itemNum = 1;

  var len = 0;
  getLen() {
    if (widget.picList == null) return 0;
    len = math.min(widget.picList.length, 6);
  }

  setW2H() {
    // var len = getLen();
    w = 0;
    h = 0;
    itemNum = 1;
    if (len == 1) {
      w = Dimens.pt328;
      h = Dimens.pt192;
      itemNum = 1;
    } else if (len == 2 || len == 4) {
      w = Dimens.pt160;
      h = Dimens.pt160;
      itemNum = 2;
    } else if (len == 3 || len == 5 || len >= 6) {
      w = Dimens.pt106;
      h = Dimens.pt106;
      itemNum = 3;
    }
  }

  /// 获取图片
  Widget getPicItem(String imgUrl, int index,
      {double w, double h, bool blast = false}) {
    return GestureDetector(
      onTap: () {
        if (widget.picList == null || widget.picList.length == 0) return;
        showPictureSwiper(context, widget.picList, index);
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                cacheManager: ImgCacheMgr(),
                imageUrl: getImgDomain() + imgUrl,
                width: w,
                height: h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          index == 5 && widget.picList.length > 6
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: Dimens.pt40,
                    height: Dimens.pt40,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(Dimens.pt40),
                    ),
                    child: Text(
                      "+" + (widget.picList.length - 6).toString(),
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget getPicList() {
    if (widget.picList == null || widget.picList.length == 0) {
      // if (widget.bUpload) {
      //   getPicItem("", blast: true);
      // }
      return Container();
    }
    List<Widget> list = [];
    for (var i = 0; i < len; i++) {
      list.add(getPicItem(widget.picList[i], i, w: w, h: h));
    }

    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemNum, //横轴三个子widget
        childAspectRatio: w / h, //宽高比为1时，子widget
        mainAxisSpacing: Dimens.pt4,
        crossAxisSpacing: Dimens.pt5,
      ),
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    getLen();
    setW2H();
    var h1 = (len / itemNum).ceil() * h + Dimens.pt5 * 2;
    return Container(
      height: h1,
      child: Stack(
        children: <Widget>[
          getPicList(),
          getPostTypeWidget(
            h: h1,
            isVip: false,
            isbuy: widget.data.isBuy,
            price: widget.data.price,
            callback: widget.onOptCallbackFn,
          )
        ],
      ),
    );
  }
}
