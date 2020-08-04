import 'package:app/config/image_cfg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/umplus/umplus.dart' as umplus;

class MiddleItem {
  final String name;
  final SvgPicture icon;
  final Function tapHandle;

  MiddleItem(this.name, this.icon, this.tapHandle);
}

class RowItem {
  final SvgPicture icon;
  final String name;
  final Function tapHandle;

  RowItem(this.icon, this.name, this.tapHandle);
}

class RowItemEx {
  final Widget icon;
  final String name;
  final Function tapHandle;
  final Widget rigthW;

  RowItemEx(this.icon, this.name, this.tapHandle, this.rigthW);
}

var rowList = [
  // RowItem(
  //   SvgPicture.asset(
  //     'assets/mine/portfolio.svg',
  //     width: 30,
  //     height: 30,
  //   ),
  //   Lang.WODEZUOPINJI,
  //   (BuildContext context) {
  //     // 打开我的作品集
  //     Navigator.of(context).pushNamed("portfolioPage");
  //     // showToast(Lang.IN_DEVELOPMENT, type: ToastType.negative);
  //   },
  // ),
  // RowItem(
  //   SvgPicture.asset(
  //     'assets/mine/heart.svg',
  //     width: 30,
  //     height: 30,
  //   ),
  //   Lang.WODESHOUCANG,
  //   (BuildContext context) {
  //     // 打开收藏页面
  //     Navigator.of(context).pushNamed("collection");
  //     // showToast(Lang.IN_DEVELOPMENT, type: ToastType.negative);
  //   },
  // ),
  // // RowItem(
  // //   SvgPicture.asset(
  // //     'assets/mine/download.svg',
  // //     width: 30,
  // //     height: 30,
  // //   ),
  // //   Lang.WODEXIAZAI,
  // //   //  我的下载
  // //   (BuildContext context) {},
  // // ),
  // RowItem(
  //     SvgPicture.asset(
  //       ImgCfg.EXCHANGE_ICON,
  //       width: 30,
  //       height: 30,
  //     ),
  //     Lang.DUIHUANMA, (BuildContext context) {
  //   Navigator.of(context).pushNamed('mineExchange');
  // }),
  RowItemEx(
    SvgPicture.asset(
      'assets/mine/notice.svg',
      width: 30,
      height: 30,
    ),
    Lang.GONGGAOXIAOXI,
    (BuildContext context) {
      umplus
          .event(umplus.Events.pvgongGaoXiaoXi, needRecordOperation: false)
          .sendEvent();
      Navigator.of(context).pushNamed('noticeList');
    },
    Container(),
  ),
  // RowItem(
  //   SvgPicture.asset(
  //     'assets/mine/order.svg',
  //     width: 30,
  //     height: 30,
  //   ),
  //   Lang.GUANYINGJILU,
  //   (BuildContext context) {
  //     // 打开观影记录页面
  //     Navigator.of(context).pushNamed("watchVideo");
  //   },
  // ),
  RowItemEx(
    SvgPicture.asset(
      'assets/mine/car.svg',
      width: 30,
      height: 30,
    ),
    Lang.KAICHEQUN,
    (BuildContext context) {
      umplus
          .event(umplus.Events.pvkaiCheQun, needRecordOperation: false)
          .sendEvent();
      Navigator.of(context).pushNamed("mineCarDiver");
    },
    Container(
      width: 80,
      child: Row(
        children: <Widget>[
          Text(Lang.LIJIJIARU),
          Icon(Icons.arrow_right),
        ],
      ),
    ),
  ),
  // RowItem(
  //   SvgPicture.asset(
  //     'assets/mine/kefu.svg',
  //     width: 30,
  //     height: 30,
  //   ),
  //   Lang.KEFU,
  //   (BuildContext context) {},
  // ),
  // SwitchRow(
  //   label: Lang.MIMASUO,
  //   changed: _pwSwitchHandle,
  //   checked: state.pwChecked,
  // ),
  RowItem(
    SvgPicture.asset(
      'assets/mine/notice.svg',
      width: 30,
      height: 30,
    ),
    Lang.MIMASUO,
    (BuildContext context) {},
  ),

  RowItemEx(
      SvgPicture.asset(
        'assets/mine/notice.svg',
        width: 30,
        height: 30,
      ),
      Lang.OFFICALEMAIL,
      (BuildContext context) {},
      Text(
        '9898huge9898@gmail.com',
        style: TextStyle(color: Color(0xff5c5c5c)),
      )),

  RowItemEx(
    SvgPicture.asset(
      'assets/mine/notice.svg',
      width: 30,
      height: 30,
    ),
    Lang.CLEANCACHE,
    (BuildContext context) {},
    Icon(Icons.arrow_right),
  ),
  RowItemEx(
    SvgPicture.asset(
      'assets/mine/notice.svg',
      width: 30,
      height: 30,
    ),
    Lang.VERSIONNUM,
    (BuildContext context) {},
    Icon(Icons.arrow_right),
  ),
];

List<MiddleItem> middleList = [
  MiddleItem(
      'VIP',
      SvgPicture.asset(
        'assets/mine/vip.svg',
        width: 37,
        height: 37,
      ), (BuildContext context) {
    umplus.event(umplus.Events.pvvip, needRecordOperation: false).sendEvent();
    Navigator.of(context).pushNamed('vipNewPage');
  }),
  MiddleItem(
      Lang.qianBao,
      SvgPicture.asset(
        'assets/mine/qianbao.svg',
        width: 35,
        height: 35,
      ), (BuildContext context) {
    umplus
        .event(umplus.Events.pvqianBao, needRecordOperation: false)
        .sendEvent();
    Navigator.of(context).pushNamed('WalletPage');
  }),
  MiddleItem(
      Lang.BUY_VIDEO,
      SvgPicture.asset(
        ImgCfg.BUY_VIDEO_ICON,
        width: 35,
        height: 35,
      ), (BuildContext context) {
    umplus
        .event(umplus.Events.pvyiGouShiPin, needRecordOperation: false)
        .sendEvent();
    Navigator.of(context).pushNamed('buyVideoPage');
  }),
  // MiddleItem(
  //     Lang.DUIHUANMA,
  //     SvgPicture.asset(
  //       'assets/mine/duihuan.svg',
  //       width: 35,
  //       height: 35,
  //     ), (BuildContext context) {
  //   Navigator.of(context).pushNamed('mineExchange');
  // }),
  MiddleItem(
      Lang.QUANMINGDAILI,
      SvgPicture.asset(
        'assets/mine/agent.svg',
        width: 35,
        height: 35,
      ), (BuildContext context) {
    umplus
        .event(umplus.Events.pvtuiGuang, needRecordOperation: false)
        .sendEvent();
    Navigator.of(context).pushNamed('UniverdalPage');
  }),
];

// void _pwSwitchHandle(bool checked) {
//   // log.i(checked);
//   if (checked) {
//     Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
//       'inputTitle': Lang.INPUTPWDWILL,
//       'appBarTitle': Lang.SETPASSOCDE,
//       'isShowAppBar': true,
//       'pwType': PwPageType.setPw
//     });
//   } else {
//     Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
//       'inputTitle': Lang.INPUTPWD,
//       'appBarTitle': Lang.REMOVEPASSCODE,
//       'isShowAppBar': true,
//       'pwType': PwPageType.delPw
//     });
//   }
//   // dispatch(SetPageActionCreator.onChangePwChecked(checked));
// }

// void _cacheClean(context) async {
//   var ok =
//       await showConfirm(context, title: Lang.TIPS, child: Text(Lang.TIPS1));
//   if (ok) {
//     await ImgCacheMgr().emptyCache();
//     dispatch(SetPageActionCreator.onSaveImageCache(0));
//   }
// }
