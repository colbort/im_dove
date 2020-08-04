import 'package:app/config/image_cfg.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';
import 'package:flutter_svg/svg.dart';

final _i20 = s.realW(20);
final _i100 = s.realW(100);
// final _i200 = s.realW(200);
final _i193 = s.realW(193);
final _i290 = s.realW(290);

final _h35 = s.realH(35);

/// 余额不足弹窗：[noBalanceDialog]
/// 没有播放次数弹窗：[noTimesDialog]
/// 购买vip弹窗：[buyVipDialog]
/// 付费弹窗：[buyDialog]
noBalanceDialog(BuildContext context) {
  return _baseDialog(context,
      titleImgName: ImgCfg.DIALOG_NOBLANCE,
      otherChildren: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Lang.DIALOG_WANZHENGBAN,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(Lang.DIALOG_2YUAN,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent))
          ],
        ),
        Text(
          Lang.DIALOG_DAYE,
          style: TextStyle(color: Color(0xff999999)),
        ),
        _okBuild(context, width: _i193, text: Lang.vipGoCharge, btnHandle: () {
          Navigator.of(context).pop();
        })
      ]);
}

/// 余额不足弹窗：[noBalanceDialog]
/// 没有播放次数弹窗：[noTimesDialog]
/// 购买vip弹窗：[buyVipDialog]
/// 付费弹窗：[buyDialog]
noTimesDialog(BuildContext context) {
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
            _okBuild(context, width: _i100, text: Lang.DIALOG_TUIGUANG,
                btnHandle: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('Promotionpage');
            }),
            _okBuild(context, width: _i100, text: Lang.DIALOG_GOUMAI,
                btnHandle: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('vipNewPage');
            }),
          ],
        )
      ]);
}

/// 余额不足弹窗：[noBalanceDialog]
/// 没有播放次数弹窗：[noTimesDialog]
/// 购买vip弹窗：[buyVipDialog]
/// 付费弹窗：[buyDialog]
buyVipDialog(BuildContext context) {
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
        _okBuild(context, width: _i193, text: Lang.DIALOG_GOUMAI,
            btnHandle: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed("vipNewPage");
        })
      ]);
}

/// 余额不足弹窗：[noBalanceDialog]
/// 没有播放次数弹窗：[noTimesDialog]
/// 购买vip弹窗：[buyVipDialog]
/// 付费弹窗：[buyDialog]
buyDialog(BuildContext context, String price, int stype) {
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
        _okBuild(context,
            width: _i193,
            text: stype == 1 ? Lang.DIALOG_YUEBUY : Lang.gochongzhi,
            btnHandle: () {
          Navigator.of(context).pop(true);
        })
      ]);
}

/// normal 图片
_baseDialog(BuildContext context,
    {String titleImgName, List<Widget> otherChildren}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          Stack(children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                titleImgName,
                width: _i290,
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
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: _i193),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[...otherChildren],
                ))
          ])
        ],
      );
    },
  );
}

/// svg 图片
_baseSvgDialog(BuildContext context,
    {String titleImgName, List<Widget> otherChildren}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          Stack(children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                titleImgName,
                width: _i290,
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
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: _i193),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[...otherChildren],
                ))
          ])
        ],
      );
    },
  );
}

Widget _okBuild(BuildContext context,
    {double width, String text, Function btnHandle}) {
  return GestureDetector(
    onTap: btnHandle,
    child: Container(
      margin: EdgeInsets.only(bottom: _i20, top: _h35),
      constraints: BoxConstraints.tightFor(width: width, height: _h35),
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
