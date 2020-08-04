import 'package:app/config/image_cfg.dart';
import 'package:app/config/text_style.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/toast/src/core/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/colors.dart';
import 'defaultWidget.dart';

/// 横线
getHengLine({w = 0, double h = 2.0, Color color, EdgeInsetsGeometry margin}) {
  if (w == 0) w = Dimens.pt360;
  if (color == null) color = c.cF7F7F7;
  if (margin == null) margin = EdgeInsets.all(0);
  return Container(
    margin: margin,
    height: h,
    width: w,
    color: color,
  );
}

/// 竖线
getSuLine({h = 0, Color color}) {
  if (h == 0) h = Dimens.pt40;
  if (color == null) color = c.cF7F7F7;
  return Container(
    height: h,
    width: 2,
    color: color,
  );
}

_baseDialog(BuildContext context,
    {String titleImgName, List<Widget> otherChildren, Function closeHandler}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
        minWidth: double.infinity, //宽度尽可能大
        minHeight: double.infinity //高度尽可能大
        ),
    child: Container(
      // alignment: Alignment.center,
      height: double.infinity,
      color: Colors.black54,
      child: Center(
        child: Container(
          color: Colors.white,
          width: Dimens.pt278,
          height: Dimens.pt350,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  titleImgName,
                  width: Dimens.pt290,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    if (closeHandler != null) closeHandler();
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: Dimens.pt192),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[...otherChildren],
                  ))
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _okBuild(BuildContext context,
    {double width, String text, Function btnHandle}) {
  return GestureDetector(
    onTap: btnHandle,
    child: Container(
      margin: EdgeInsets.only(bottom: Dimens.pt20, top: Dimens.pt35),
      constraints: BoxConstraints.tightFor(width: width, height: Dimens.pt35),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Color(0xffFFE03C)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}

/// 没有播放次数弹窗：[noTimesDialog]
noTimesDialog(BuildContext context, Function okHandler, Function closeHandler) {
  return _baseDialog(context,
      titleImgName: ImgCfg.DIALOG_NOTIME,
      otherChildren: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Lang.DIALOG_NO_TIMES,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Text(
          Lang.DIALOG_TUIGUANG_TIPS,
          style: TextStyle(color: Color(0xff999999)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _okBuild(context, width: Dimens.pt100, text: Lang.DIALOG_TUIGUANG,
                btnHandle: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushNamed('Promotionpage');
              if (okHandler != null) okHandler();
            }),
            _okBuild(context, width: Dimens.pt100, text: Lang.DIALOG_GOUMAI,
                btnHandle: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushNamed('vipNewPage');
              if (okHandler != null) okHandler();
            }),
          ],
        )
      ],
      closeHandler: closeHandler);
}

/// 购买vip弹窗：[buyVipDialog]
buyVipDialog(BuildContext context, Function okHandler, Function closeHandler) {
  return _baseDialog(context,
      titleImgName: ImgCfg.DIALOG_VIP,
      otherChildren: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Lang.VIP_ZHUANXIANG,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Text(
          Lang.VIP_JINGXUAN,
          style: TextStyle(color: Color(0xff999999)),
        ),
        _okBuild(context, width: Dimens.pt192, text: Lang.DIALOG_GOUMAI,
            btnHandle: () {
          // Navigator.of(context).pop();
          Navigator.of(context).pushNamed("vipNewPage");
          if (okHandler != null) okHandler();
        })
      ],
      closeHandler: closeHandler);
}

/// 付费弹窗：[buyDialog]
buyDialog(BuildContext context, String price, int stype, Function okHandler,
    Function closeHandler) {
  return _baseSvgDialog(context,
      titleImgName: ImgCfg.DIALOG_BUY,
      otherChildren: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Lang.DIALOG_WANZHENGBAN +
                  Lang.val(Lang.DIALOG_NYUAN, args: [price]),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Text(
          Lang.DIALOG_DAYE,
          style: TextStyle(color: Color(0xff999999)),
        ),
        _okBuild(
          context,
          width: Dimens.pt192,
          text: stype == 1 ? Lang.DIALOG_YUEBUY : Lang.gochongzhi,
          btnHandle: () {
            if (okHandler != null) okHandler();
          },
        )
      ],
      closeHandler: closeHandler);
}

/// svg 图片
_baseSvgDialog(BuildContext context,
    {String titleImgName, List<Widget> otherChildren, Function closeHandler}) {
  return ConstrainedBox(
    constraints: BoxConstraints(
        minWidth: double.infinity, //宽度尽可能大
        minHeight: double.infinity //高度尽可能大
        ),
    child: Container(
      // alignment: Alignment.center,
      height: double.infinity,
      color: Colors.black54,
      child: Center(
        child: Container(
          color: Colors.white,
          width: Dimens.pt278,
          height: Dimens.pt350,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  titleImgName,
                  width: Dimens.pt290,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    if (closeHandler != null) closeHandler();
                    // Navigator.of(context).pop(false);
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: Dimens.pt192),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[...otherChildren],
                  ))
            ],
          ),
        ),
      ),
    ),
  );
}

/// 获取视频标签
Widget getVideoLevelWidget(
    bool isVip, bool needPay, bool isBought, String cost) {
  if (isVip) {
    return getVideoVipFreeWidget();
  } else if (needPay) {
    return getVideoBuyWidget(isBought, cost);
  } else {
    return Container();
  }
}

/// vip免费视频标签
Widget getVideoVipFreeWidget() {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      ImageLoader.withP(
        ImageType.IMAGE_SVG,
        ImgCfg.MAIN_BG_VIDEO_VIP_FREE,
        width: Dimens.pt85,
        height: Dimens.pt26,
      ).load(),
      Container(
        margin: EdgeInsets.only(left: Dimens.pt8),
        child: Text(
          Lang.VIP_FREE,
          style: TextStyle(
              fontSize: t.fontSize14,
              color: Colors.white,
              fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}

/// 购买视频标签
Widget getVideoBuyWidget(bool isBought, String cost) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      ImageLoader.withP(
        ImageType.IMAGE_SVG,
        ImgCfg.MAIN_BG_VIDEO_BUY,
        width: Dimens.pt85,
        height: Dimens.pt26,
      ).load(),
      isBought
          ? Text(Lang.BOUGHT,
              style: TextStyle(
                  fontSize: t.fontSize16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ImageLoader.withP(ImageType.IMAGE_SVG, ImgCfg.MAIN_ICON_COIN)
                    .load(),
                Container(
                  margin: EdgeInsets.only(left: Dimens.pt5),
                  child: Text(cost,
                      style: TextStyle(
                          fontSize: t.fontSize16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                ),
              ],
            ),
    ],
  );
}

/// 获取vip等级widget
Widget getVipLvWidget({w = 0, lv = 0}) {
  var scale = 1.0;
  if (w != 0) scale = w / Dimens.pt70;
  return Offstage(
    offstage: lv == 0,
    child: Transform.scale(
      scale: scale,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          /// 背景
          Container(
            margin: EdgeInsets.only(left: Dimens.pt8, top: Dimens.pt4),
            width: Dimens.pt70,
            height: Dimens.pt15,
            decoration: BoxDecoration(
              color: c.cFCC12D,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),

          /// vip 等级
          Positioned(
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  ImgCfg.MINE_VIP_BG,
                  width: Dimens.pt25,
                  height: Dimens.pt25,
                ),
                Container(
                  margin: EdgeInsets.only(top: Dimens.pt4, left: Dimens.pt3),
                  height: Dimens.pt15,
                  alignment: Alignment.center,
                  child: Text(
                    "VIP" + lv.toString().padLeft(2, " "),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// 显示默认widget
showLoadingWidget(bool isInit, [double radius = 10]) {
  return Center(
    child: isInit
        ? new CupertinoActivityIndicator(
            radius: radius,
          )
        : showDefaultWidget(DefaultType.noData),
  );
}

/// 获取性别
/// 1女 2 男
Widget getSexWidget(int gender) {
  return gender == 1
      ? Container(
          child: SvgPicture.asset(
            'assets/mine/female.svg',
            width: 12,
            color: Color.fromRGBO(255, 10, 165, 1),
          ),
          margin: EdgeInsets.only(left: 5),
        )
      : SvgPicture.asset(
          'assets/mine/man.svg',
        );
}

/// 显示签名的弹窗
Future<bool> showSignDialog(BuildContext context,
    {String title, String defaultContent, Function callback}) async {
  var res = await showDialog<bool>(
    context: context,
    builder: (_) {
      TextEditingController controller = TextEditingController();
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.pt40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: Dimens.pt280,
                  height: Dimens.pt315,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      /// 标题
                      Positioned(
                        top: Dimens.pt10,
                        child: Text(
                          title ?? Lang.SHURU_JIANJIE,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                      /// 输入框
                      Positioned(
                        top: Dimens.pt45,
                        child: Container(
                          width: Dimens.pt256,
                          height: Dimens.pt192,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 2.0, color: Colors.grey[200]),
                          ),
                          // color: Colors.redAccent,
                          child: TextField(
                            autofocus: false,
                            cursorColor: Colors.red,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.all(Dimens.pt10),
                              counterText: "",
                              hintText: (defaultContent == null ||
                                      defaultContent.isEmpty)
                                  ? Lang.SHURU_JIANJIE
                                  : defaultContent,
                              // labelText: Lang.SHURU_JIANJIE,
                              border: InputBorder.none,
                            ),
                            controller: controller,
                          ),
                        ),
                      ),

                      /// 关闭按钮
                      Positioned(
                        top: Dimens.pt14,
                        right: Dimens.pt20,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            color: c.cD8D8D8,
                          ),
                        ),
                      ),

                      /// 确认按钮
                      Positioned(
                        top: Dimens.pt260,
                        child: GestureDetector(
                          onTap: () {
                            var d = controller.text;
                            if (d == null || d.isEmpty) {
                              showToast(title ?? Lang.SHURU_JIANJIE);
                              return;
                            }
                            Navigator.of(context).pop();
                            if (callback != null) {
                              callback(controller.text);
                            }
                          },
                          child: Container(
                            width: Dimens.pt250,
                            height: Dimens.pt40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.0),
                              color: c.cFFE300,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              Lang.QUEDING,
                              style: TextStyle(
                                fontSize: 16,
                                height: 22 / 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
  return res == null ? false : res;
}
