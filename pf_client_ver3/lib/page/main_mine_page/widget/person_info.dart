import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/image_cache/cached_network_image.dart';
import '../state.dart';

Widget personInfo(context, MainMineState state) {
  double _w100 = MediaQuery.of(context).size.width;
  List _recordList = [
    {
      'label': Lang.AVCISHU,
      'value':
          state.totalWatch == -1 ? Lang.WUXIAN : state.avWatchRemain.toString(),
      "stype": 0,
    },
    {
      'label': Lang.DUANSHIPINCISHU,
      'value': state.totalWatch == -1
          ? Lang.WUXIAN
          : state.shortWatchRemain.toString(),
      "stype": 1,
    },
    {
      'label': Lang.TUIGUANGRENSHU,
      'value': state.promotion.toString(),
      "stype": 2,
    },
  ];

  /// 推广
  Widget _recordInfo() {
    int lestDay = showLestDay(state.promotionExpireDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ..._recordList.map(
          (f) {
            return Container(
              height: Dimens.pt55,
              // width: Dimens.pt100,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Text(
                        f['value'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(top: s.realH(4)),
                    child: Text(
                      f['label'],
                      style: TextStyle(
                        fontSize: 14,
                        color: c.c979797,
                      ),
                    ),
                  ),
                  lestDay > 0 && lestDay <= 3 && state.vipExpireDate != null
                      ? Container(
                          // margin: EdgeInsets.symmetric(vertical: 2),
                          // color: Colors.green,
                          child: Offstage(
                            offstage: f['stype'] != 2 ||
                                false, //state.promotionExpireDate,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: c.cFFE2E2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9))),
                              padding: EdgeInsets.only(
                                  left: s.realW(5),
                                  top: s.realH(2),
                                  right: s.realW(5),
                                  bottom: s.realH(3)),
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
            );
          },
        )
      ],
    );
  }

  return Container(
      padding: EdgeInsets.only(
        top: Dimens.pt6,
        // left: Dimens.pt16,
        // right: Dimens.pt16,
      ),
      height: Dimens.pt240,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            width: _w100,
            height: Dimens.pt163,
            child: Container(
              child: Stack(
                children: <Widget>[
                  //头像
                  Positioned(
                      left: s.realW(16),
                      top: 6,
                      child: state.logo == '' || state.logo == null
                          ? SizedBox(
                              width: Dimens.pt60,
                              height: Dimens.pt60,
                              child: SvgPicture.asset(
                                'assets/mine/default_man.svg',
                                fit: BoxFit.contain,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(Dimens.pt65),
                              child: CachedNetworkImage(
                                imageUrl: state.logo,
                                cacheManager: ImgCacheMgr(),
                                width: Dimens.pt60,
                                height: Dimens.pt60,
                                fit: BoxFit.cover,
                              ),
                            )),

                  Positioned(
                    right: s.realW(16),
                    top: s.realH(13),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(page_mineEditPerson,
                            arguments: {
                              'gender': state.gender,
                              'nickName': state.nickName,
                              'logo': state.mobile
                            });
                      },
                      child: SvgPicture.asset(
                        'assets/mine/edit.svg',
                        fit: BoxFit.contain,
                        width: Dimens.pt20,
                        height: Dimens.pt20,
                      ),
                    ),
                  ),
                  // child: Stack(
                  //   children: <Widget>[

                  //     // Image(
                  //     //   image: state.level == 0
                  //     //       ? AssetImage('assets/mine/circle.png')
                  //     //       : state.level == 2
                  //     //           ? AssetImage('assets/mine/vip_1.png')
                  //     //           : state.level == 3
                  //     //               ? AssetImage('assets/mine/vip_2.png')
                  //     //               : state.level == 4
                  //     //                   ? AssetImage('assets/mine/vip_3.png')
                  //     //                   : state.level == 1
                  //     //                       ? AssetImage(
                  //     //                           'assets/mine/circle.png')
                  //     //                       : AssetImage(
                  //     //                           'assets/mine/circle.png'),
                  //     //   fit: BoxFit.fill,
                  //     //   width: Dimens.pt70,
                  //     //   height: state.level == 0 || state.level == 1
                  //     //       ? Dimens.pt70
                  //     //       : Dimens.pt75,
                  //     // ),
                  //   ],
                  // ),

                  //昵称和性别 vip
                  Positioned(
                    left: Dimens.pt88,
                    top: Dimens.pt10,
                    // right: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                state.nickName != null ? state.nickName : "",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: s.realW(15),
                                height: s.realH(15),
                                child: SvgPicture.asset(
                                  state.gender != 1
                                      ? 'assets/mine/boy.svg'
                                      : 'assets/mine/girl.svg',
                                  //  width: 12,
                                  //  color: Color.fromRGBO(255, 10, 165, 1),
                                ),
                                margin: EdgeInsets.only(left: 5),
                              )
                              // state.gender == 1
                              //     ? Container(
                              //         child: SvgPicture.asset(
                              //           'assets/mine/girl.svg',
                              //           width: 12,
                              //           color: Color.fromRGBO(255, 10, 165, 1),
                              //         ),
                              //         margin: EdgeInsets.only(left: 5),
                              //       )
                              //     : SvgPicture.asset(
                              //         'assets/mine/boy.svg',
                              //       ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),

                          /// TODO vip
                          getVipExpireState() != 1
                              ? getVipLvWidget(lv: 1)
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  // //设置
                  // Positioned(
                  //   right: 16,
                  //   top: 10,
                  //   child: GestureDetector(
                  //     child: Image(
                  //       image: AssetImage('assets/mine/set.png'),
                  //       width: 28,
                  //       height: 28,
                  //     ),
                  //     onTap: () {
                  //       Navigator.of(context).pushNamed('setPage',
                  //           arguments: {'mobile': state.mobile});
                  //     },
                  //   ),
                  // ),
                  /// TODO vip 经验
                  // Positioned(
                  //   top: Dimens.pt88,
                  //   child: Offstage(
                  //     offstage: false,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           margin: EdgeInsets.only(right: Dimens.pt6),
                  //           child: Text(
                  //             "V2",
                  //             style: TextStyle(color: c.cFF8A52),
                  //           ),
                  //         ),
                  //         Container(
                  //           width: Dimens.pt284,
                  //           height: Dimens.pt6,
                  //           decoration: BoxDecoration(
                  //             color: Colors.black12,
                  //             borderRadius: BorderRadius.all(
                  //               Radius.circular(3.0),
                  //             ),
                  //           ),
                  //           child: FittedBox(
                  //             alignment: Alignment.centerLeft,
                  //             child: Container(
                  //               /// 经验
                  //               width: 0,
                  //               height: Dimens.pt6,
                  //               decoration: BoxDecoration(
                  //                 gradient: LinearGradient(
                  //                   colors: [c.cFF8A52, c.cFF5300],
                  //                 ),
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(3.0),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.only(left: Dimens.pt6),
                  //           child: Text("V3"),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /// 数量
                  Positioned(
                    // left: 0,
                    // right: 0,
                    top: Dimens.pt103,
                    child: Container(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            height: Dimens.pt55,
                            width: Dimens.pt360,
                            child: _recordInfo(),
                          ),
                          Positioned(
                            left: Dimens.pt100,
                            child: getSuLine(h: Dimens.pt43),
                          ),
                          Positioned(
                            left: Dimens.pt240,
                            child: getSuLine(h: Dimens.pt43),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 头像点击区域
                  Positioned(
                    left: 0,
                    right: 40,
                    top: 0,
                    height: Dimens.pt100,
                    child: GestureDetector(
                      onTap: () {
                        if (state.mobile != '') {
                          Navigator.of(context).pushNamed('mineEditPerson',
                              arguments: {
                                'nickName': state.nickName,
                                'gender': state.gender,
                                'logo': state.logo
                              });
                        } else {
                          Navigator.of(context).pushNamed('phone');
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Dimens.pt12,
            left: 0,
            right: 0,
            height: Dimens.pt52,
            child: GestureDetector(
              onTap: () {
                //全民代理
                Navigator.of(context).pushNamed('Promotionpage');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.pt13),

                // decoration: BoxDecoration(
                //   image: DecorationImage(image: SvgPicture.asset('assetName')),
                //   color: c.cF7EFD8,
                //   borderRadius: BorderRadius.circular(Dimens.pt12),
                // ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: SvgPicture.asset(
                      'assets/mine/tg_bg.svg',
                      fit: BoxFit.fill,
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: s.realW(13)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: Dimens.pt2),
                                child: SvgPicture.asset(ImgCfg.COMMON_MONEY_BG),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: Dimens.pt2),
                                alignment: Alignment.center,
                                child: Text(
                                  Lang.TUIGUANG_TIP,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   width: 5,
                        // ),
                        Container(
                          margin: EdgeInsets.only(right: s.realW(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: Dimens.pt76,
                                height: Dimens.pt26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Lang.QUTUIGUANG,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: Dimens.pt10,
                                            right: Dimens.pt10),
                                        child: SvgPicture.asset(
                                            ImgCfg.COMMON_ARROW_BG)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
}
