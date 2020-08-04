import 'package:app/config/colors.dart';
import 'package:app/config/defs.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/main_mine_page/widget/BaseRow.dart';
import 'package:app/page/main_mine_page/widget/person_info.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'action.dart';
import 'state.dart';
import './widget/item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/hosts.dart';
import 'package:app/umplus/umplus.dart' as umplus;

Widget buildView(
    MainMineState state, Dispatch dispatch, ViewService viewService) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  final middleTitles = [
    Lang.qianBao,
    Lang.VIP,
    Lang.DUIHUANMA,
    Lang.KEFU,
    // Lang.BUY_VIDEO,
    // Lang.WODEZUOPINJI,
    // Lang.GUANYINGJILU,
    // Lang.SHOUCANG,
  ];
  final middleTitlesIcon = [
    1,
    0,
    4,
    7,
  ];
  final middleTapRoutNames = [
    'vipNewPage',
    'WalletPage',
    'buyVideoPage',
    'portfolioPage',
    'mineExchange',
    'watchVideo',
    'collection',
    ''
  ];
  final middleTapRouteEvent = [
    umplus.Events.pvvip,
    umplus.Events.pvqianBao,
    umplus.Events.pvyiGouShiPin,
    umplus.Events.pvzuoPinJi,
    umplus.Events.pvduiHuanMa,
    umplus.Events.pvguanYingJiLu,
    umplus.Events.pvshouCang
  ];

  void _pwSwitchHandle(bool checked) {
    // log.i(checked);
    if (checked) {
      Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
        'inputTitle': Lang.INPUTPWDWILL,
        'appBarTitle': Lang.SETPASSOCDE,
        'isShowAppBar': true,
        'pwType': PwPageType.setPw
      });
    } else {
      Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
        'inputTitle': Lang.INPUTPWD,
        'appBarTitle': Lang.REMOVEPASSCODE,
        'isShowAppBar': true,
        'pwType': PwPageType.delPw
      });
    }
    dispatch(MainMineActionCreator.onChangePwChecked(checked));
  }

  void _cacheClean() async {
    var ok = await showConfirm(viewService.context,
        title: Lang.TIPS, child: Text(Lang.TIPS1));
    if (ok) {
      await ImgCacheMgr().emptyCache();
      dispatch(MainMineActionCreator.onSaveImageCache(0));
    }
  }

  final _imgCache = (state.imageCache / 1024 / 1024).floorToDouble();
  final lestDay = showLestDay(state.vipExpireDate);

  return SafeArea(
      child: SingleChildScrollView(
    // physics: NeverScrollableScrollPhysics(),
    child: Container(
      color: c.cF7F7F7, // Color.fromRGBO(242, 242, 242, 1.0),
      // height: MediaQuery.of(viewService.context).size.height -
      //     MediaQuery.of(viewService.context).padding.top -
      //     MediaQuery.of(viewService.context).padding.bottom,
      child: Column(
        children: <Widget>[
          /// 个人资料信息
          personInfo(viewService.context, state),

          /// 钱包
          Container(
            height: s.realH(113),
            color: Colors.white,
            padding: EdgeInsets.only(top: Dimens.pt16),
            margin: EdgeInsets.only(top: Dimens.pt2, bottom: Dimens.pt2),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    var index1 = middleTitlesIcon[index];
                    if (index1 == 7) {
                      //在线客服
                      if (state.chatURL != null) {
                        var url =
                            hosts.host.substring(0, hosts.host.length - 4) +
                                state.chatURL;
                        PermissionHandler()
                            .requestPermissions([PermissionGroup.camera]);
                        umplus
                            .event(umplus.Events.pvzaiXianKeFu,
                                needRecordOperation: false)
                            .sendEvent();
                        Navigator.of(viewService.context).pushNamed(
                            'WebviewPage',
                            arguments: {'url': url, 'pageName': Lang.KEFU});
                      }
                    } else {
                      umplus
                          .event(middleTapRouteEvent[index1],
                              needRecordOperation: false)
                          .sendEvent();
                      // if (index == 3) {
                      //   var nickName = await ls.get(StorageKeys.NAME);
                      //   var backCover = await ls.get(StorageKeys.BACKCOVER);
                      //   var singature = await ls.get(StorageKeys.SIGNATUER);
                      //   Navigator.of(viewService.context)
                      //       .pushNamed(middleTapRoutNames[index], arguments: {
                      //     'nickName': nickName,
                      //     'backCover': backCover,
                      //     'singature': singature
                      //   });
                      // } else {
                      //   Navigator.pushNamed(context, middleTapRoutNames[index]);
                      // }
                      // Navigator.pushNamed(context, 'videoPage',
                      //     arguments: {'videoId': 117646});
                      Navigator.pushNamed(context, middleTapRoutNames[index1]);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: Dimens.pt40,
                          width: Dimens.pt40,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/mine/middle_icon_' +
                                  middleTitlesIcon[index].toString() +
                                  '.svg',
                              height: index == 3 ? Dimens.pt30 : Dimens.pt40,
                              width: index == 3 ? Dimens.pt30 : Dimens.pt40,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimens.pt5),
                          child: Text(
                            middleTitles[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        lestDay > 0 &&
                                lestDay <= 3 &&
                                state.vipExpireDate != null
                            ? Container(
                                child: Offstage(
                                  offstage: middleTitlesIcon[index] != 0 ||
                                      false, //state.vipExpireDate
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: c.cFFE2E2,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9))),
                                    padding: EdgeInsets.only(
                                        left: s.realW(5),
                                        top: s.realH(2),
                                        right: s.realW(5),
                                        bottom: s.realH(3)),
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: Dimens.pt6, vertical: 1),
                                    child: Text(
                                      "$lestDay天过期",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: c.cEC0035,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              },
              itemCount: middleTitles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0),
            ),
          ),

          //导航列表
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: Dimens.pt30),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
              child: Column(
                children: <Widget>[
                  /// 全民代理
                  state.showAgent
                      ? rowItemEx(
                          SvgPicture.asset(
                            'assets/mine/dai.svg',
                            fit: BoxFit.fitWidth,
                          ),
                          Lang.QUANMINGDAILI,
                          true,
                          () {
                            // umplus
                            //     .event(umplus.Events.pvgongGaoXiaoXi,
                            //         needRecordOperation: false)
                            //     .sendEvent();
                            Navigator.of(viewService.context)
                                .pushNamed('UniverdalPage');
                            // Navigator.of(viewService.context).pushNamed('noticeList');
                          },
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_right,
                                size: 32,
                                color: c.cA1A1A1,
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  /// 开车群
                  rowItemEx(
                    SizedBox(
                      width: s.realW(22),
                      height: s.realH(22),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/mine/kaiche.svg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Lang.KAICHEQUN,
                    true,
                    () {
                      umplus
                          .event(umplus.Events.pvkaiCheQun,
                              needRecordOperation: false)
                          .sendEvent();
                      Navigator.of(viewService.context)
                          .pushNamed("mineCarDiver");
                    },
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          Lang.LIJIJIARU,
                          style: TextStyle(color: c.cA1A1A1),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 32,
                          color: c.cA1A1A1,
                        ),
                      ],
                    ),
                  ),

                  /// 密码锁
                  SwitchRow(
                    icon: SizedBox(
                      width: s.realW(22),
                      height: s.realH(22),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/mine/lock.svg',
                        ),
                      ),
                    ),
                    label: Lang.MIMASUO,
                    changed: _pwSwitchHandle,
                    checked: state.pwChecked,
                  ),

                  /// 邮箱
                  SetRow(
                    icon: SvgPicture.asset(
                      'assets/mine/email.svg',
                      width: 30,
                      height: 30,
                    ),
                    value: '9898huge9898@gmail.com',
                    label: Lang.OFFICALEMAIL,
                  ),

                  /// 清除缓存
                  SetRow(
                    icon: SvgPicture.asset(
                      'assets/mine/trash.svg',
                      width: 30,
                      height: 30,
                    ),
                    value: '${_imgCache}M',
                    label: Lang.CLEANCACHE,
                    tabHandle: _cacheClean,
                  ),

                  /// 版本号
                  SetRow(
                    icon: SvgPicture.asset(
                      'assets/mine/clock.svg',
                      width: 30,
                      height: 30,
                    ),
                    value: state.version,
                    label: Lang.VERSIONNUM,
                    tabHandle: () {},
                  ),
                ],
                // children: rowList.map((f) {
                //   var index = rowList.indexOf(f);
                //   return rowItemEx(f.icon, f.name, index != rowList.length - 1,
                //       () {
                //     f.tapHandle(viewService.context);
                //   }, f.rigthW);
                // }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}
