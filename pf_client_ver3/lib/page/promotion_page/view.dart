import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/utils/screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    PromotionState state, Dispatch dispatch, ViewService viewService) {
  final double i360 = s.realW(360);
  final double i197 = s.realW(197);
  final double i218 = s.realW(218);
  final double i307 = s.realW(307);
  final double i60 = s.realW(60);
  final double i68 = s.realW(68);
  final double i224 = s.realW(224);
  final double i247 = s.realW(247);
  final double i227 = s.realW(227);
  final double i30 = s.realW(30);
  final double i150 = s.realW(150);
  // final double i28 = s.realW(28);
  final double i348 = s.realW(348);
  // final double i156 = s.realW(156);
  final double i47 = s.realW(47);
  final double i446 = s.realW(446);
  // final double i20 = s.realW(20);
  // final double i16 = s.realW(16);
  // final double i9 = s.realW(9);
  // final double i23 = s.realW(23);
  // final double i111 = s.realW(111);

  // final double i168 = s.realW(168);
  // final double i25 = s.realW(25);
  final double i38 = s.realW(38);

  var appBar = AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          padding: EdgeInsets.only(right: 1),
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          // tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        );
      },
    ),
    backgroundColor: Colors.white,
    title: Container(
      width: i307,
      // color: Colors.red,
      padding: EdgeInsets.only(right: i60),
      alignment: Alignment.center,
      child: Text(
        Lang.TUIGUANGDAILi,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, height: 28 / 20, color: Colors.black),
      ),
    ),
  );

  /// 背景颜色
  var bgW = Container(
    margin: EdgeInsets.only(top: i218),
    child: Container(
      width: i360,
      height: i197,
      child: SvgPicture.asset(ImgCfg.MINE_BG),
    ),
  );

  /// 提示文本
  var titleW = Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: s.realH(292)),
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: Lang.FENGXIANG,
            style: TextStyle(
                color: Color(0xff222222),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: Lang.ZHUAN,
            style: TextStyle(
                color: Color(0xff222222),
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: Lang.LINGHUAQIAN,
            style: TextStyle(
                color: Color(0xff222222),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );

  /// 二维码 图片
  var qrW = Container(
    width: i224,
    height: i247,
    margin: EdgeInsets.only(top: i30),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x1f000000), blurRadius: 4.0),
        ],
        borderRadius: BorderRadius.circular(5.0)),
    child: Container(
      width: i150,
      height: i150,
      margin: EdgeInsets.only(top: i30, left: i38, right: i38, bottom: i68),
      child: (state.inviteCode != null && state.inviteCode.length > 0)
          ? Container(
              alignment: Alignment.center,
              height: i150,
              width: i150,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     width: 1.0,
              //     color: Color(0xffFF5B6F),
              //   ),
              // ),
              child: RepaintBoundary(
                key: state.pipCaptureKey,
                child: QrImage(
                  version: QrVersions.auto,
                  padding: EdgeInsets.all(4.0),
                  data: state.url + "?p=" + state.inviteCode,
                  size: i150,
                ),
              ),
            )
          : Container(),
    ),
  );

  /// 邀请码
  var yaoqingW = Container(
    margin: EdgeInsets.only(top: i227),
    child: Text(
      Lang.WODEYAOQINGMA + (state.inviteCode == null ? "" : state.inviteCode),
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 18, color: Color(0xff373737), height: 25 / 18),
    ),
  );

  /// 按钮
  var btnsW = Container(
    width: i360,
    height: i47,
    // color: Colors.red,
    margin: EdgeInsets.only(top: i348),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
          // color: Color(0xff3d3d3d),
          // 复制链接分享
          child: Stack(
            children: <Widget>[
              Image.asset(
                ImgCfg.COPY_BG,
                width: s.realW(133),
                height: s.realH(43),
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                width: s.realW(133),
                height: s.realH(40),
                child: Text(
                  Lang.FUZHILIANJIE,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
            ],
          ),

          onTap: () {
            dispatch(PromotionActionCreator.onCopyClick());
          },
        ),
        GestureDetector(
          // 保存图片分享
          child: Stack(
            children: <Widget>[
              Image.asset(
                ImgCfg.SAVE_BG,
                width: s.realW(133),
                height: s.realH(43),
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                width: s.realW(133),
                height: s.realH(40),
                child: Text(
                  Lang.BAOCUNTUPIAN,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
          onTap: () {
            dispatch(PromotionActionCreator.onSavePicClick());
          },
        )
      ],
    ),
  );

  /// 推广规则
  var tuiguagnRuleW = Container(
    alignment: Alignment.topCenter,
    margin: EdgeInsets.only(top: i446, left: s.realW(45), right: s.realW(45)),
    child: Text(
      Lang.TIPS2,
      style: TextStyle(fontSize: 16, color: Color(0xff363636)),
    ),
  );

  /// 规则title
  // var rule1W = Container(
  //   margin: EdgeInsets.only(top: i16, bottom: i9),
  //   // height: 15,
  //   // width: 15,
  //   // decoration: BoxDecoration(color: Color(0xffF9D44F)),
  //   child: Stack(
  //     children: <Widget>[
  //       Container(
  //         height: 5,
  //         width: 5,
  //         margin: EdgeInsets.only(top: 5),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5.0),
  //           color: Color(0xffF9D44F),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(left: i9),
  //         child: Text(
  //           Lang.GUANYINGCISHU,
  //           style: TextStyle(fontSize: 13, color: Colors.black),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  // var rule2W = Container(
  //   // margin: EdgeInsets.only(top: i16, bottom: i9),
  //   // height: 15,
  //   // width: 15,
  //   // decoration: BoxDecoration(color: Color(0xffF9D44F)),
  //   child: Stack(
  //     children: <Widget>[
  //       Container(
  //         height: 5,
  //         width: 5,
  //         margin: EdgeInsets.only(top: 5),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5.0),
  //           color: Color(0xffF9D44F),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(left: i9),
  //         child: Text(
  //           Lang.TUIGUANG_RULE1,
  //           style: TextStyle(fontSize: 13, color: Colors.black),
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  // /// 横线
  // var lineW = Container(
  //   height: 1,
  //   margin: EdgeInsets.only(top: i9 * 2),
  //   decoration: BoxDecoration(color: Color(0xff191919)),
  // );

  // /// 攻略标题
  // var gonglueTW = Container(
  //   // color: Colors.red,
  //   height: i23,
  //   margin: EdgeInsets.only(top: i20),
  //   alignment: Alignment.center,
  //   child: Text(
  //     Lang.YAOQINGGONGLUE,
  //     style: TextStyle(
  //         fontSize: 18, color: Color(0xff363636), fontWeight: FontWeight.bold),
  //   ),
  // );
  // var drule1W = Container(
  //   margin: EdgeInsets.only(top: i13),
  //   alignment: Alignment.center,
  //   child: Text(
  //     Lang.TUIGUANG_DETAIL1,
  //     style: TextStyle(fontSize: 12),
  //   ),
  // );

  // /// setp1
  // var step1W = Container(
  //   margin: EdgeInsets.only(top: i23),
  //   child: SvgPicture.asset(ImgCfg.MINE_STEP1),
  // );

  // /// 内容1
  // var step1CW = Container(
  //   margin: EdgeInsets.only(top: i13),
  //   child: Text(
  //     Lang.TUIGUANG_DETAIL2,
  //     style: TextStyle(fontSize: 12),
  //   ),
  // );

  // /// setp2
  // var step2W = Container(
  //   margin: EdgeInsets.only(top: i23),
  //   child: SvgPicture.asset(ImgCfg.MINE_STEP2),
  // );

  // /// 内容2
  // var step2CW = Container(
  //   margin: EdgeInsets.only(top: i13),
  //   child: Text(
  //     Lang.TUIGUANG_DETAIL3,
  //     style: TextStyle(fontSize: 12),
  //   ),
  // );

  // /// setp2
  // var step3W = Container(
  //   margin: EdgeInsets.only(top: i23),
  //   child: SvgPicture.asset(ImgCfg.MINE_STEP3),
  // );

  // /// 内容2详情
  // var step2Detial = Container(
  //   height: i111,
  //   margin: EdgeInsets.only(top: i13),
  //   decoration: BoxDecoration(
  //     color: Color(0xffFEFAED),
  //     // color: Colors.red,
  //     borderRadius: BorderRadius.circular(4.0),
  //   ),
  //   child: Flex(
  //     direction: Axis.horizontal,
  //     children: <Widget>[
  //       Container(
  //         margin: EdgeInsets.only(left: i13, right: i13, top: i13),
  //         // color: Colors.green,
  //         width: i168,
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(
  //                   margin: EdgeInsets.only(right: i9),
  //                   child: SvgPicture.asset(ImgCfg.MINE_PENGYOUQUAN),
  //                 ),
  //                 Container(
  //                     margin: EdgeInsets.only(right: i9),
  //                     child: SvgPicture.asset(ImgCfg.MINE_QUANZI_NOR)),
  //                 Container(
  //                     margin: EdgeInsets.only(right: i9),
  //                     child: SvgPicture.asset(ImgCfg.MINE_QQ)),
  //               ],
  //             ),
  //             Container(
  //               // color: Colors.red,
  //               margin: EdgeInsets.only(top: i13),
  //               child: Text(
  //                 Lang.tuiGuangDetail4,
  //                 style: TextStyle(fontSize: 12, height: 17 / 12),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         height: i25,
  //         width: 1,
  //         decoration: BoxDecoration(color: Colors.black),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(left: i13, top: i13),
  //         // color: Colors.green,
  //         width: i111,
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Container(
  //                   margin: EdgeInsets.only(right: i9),
  //                   child: SvgPicture.asset(ImgCfg.MINE_WANJU),
  //                 ),
  //                 Container(
  //                     margin: EdgeInsets.only(right: i9),
  //                     child: SvgPicture.asset(ImgCfg.MINE_WO)),
  //               ],
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: i13),
  //               child: Text(
  //                 Lang.TUIGUANG_DETAIL5,
  //                 style: TextStyle(fontSize: 12, height: 17 / 12),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  // /// 内容3
  // var step3CW = Container(
  //   margin: EdgeInsets.only(top: i13, bottom: i60),
  //   child: Text(
  //     Lang.TUIGUANG_DETAIL6,
  //     style: TextStyle(fontSize: 12),
  //   ),
  // );

  /// 内容4
  // var step3C1W = Container(
  //   margin: EdgeInsets.only(top: 4, bottom: i60),
  //   child: Text(
  //     Lang.TUIGUANG_DETAIL7,
  //     style: TextStyle(fontSize: 12, color: Colors.grey),
  //   ),
  // );
  //推广福利
  var promote = Container(
    child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 23, right: 16, top: 30),
          width: s.realW(360),
          alignment: Alignment.center,
          height: s.realH(164),
          decoration: BoxDecoration(
            color: Color(0xFFFFD59D),
            borderRadius: new BorderRadius.circular(7.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Color(0xFFFFD59D), width: 1),
            borderRadius: new BorderRadius.circular(7.0),
          ),
          margin: EdgeInsets.only(left: 20, right: 20, top: 24),
          width: s.realW(360),
          height: s.realH(164),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 12),
                width: s.realW(130),
                height: s.realH(20),
                child: Image.asset(ImgCfg.PROMOTE_TEXT),
              ),
              Container(
                width: s.realW(279),
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: s.realW(28),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "1、",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffB59483)),
                      ),
                    ),
                    Container(
                      width: s.realW(231),
                      alignment: Alignment.topLeft,
                      child: Text(
                        Lang.TUIGUANGFULINEIRONG1,
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffB59483)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: s.realW(279),
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: s.realW(28),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "2、",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffB59483)),
                      ),
                    ),
                    Container(
                      width: s.realW(231),
                      alignment: Alignment.topLeft,
                      child: Text(
                        Lang.TUIGUANGFULINEIRONG2,
                        style:
                            TextStyle(fontSize: 18, color: Color(0xffB59483)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
  var addGroup = Container(
    margin: EdgeInsets.only(top: s.realH(64)),
    child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 23, right: 16, top: 6),
          width: s.realW(360),
          alignment: Alignment.center,
          height: s.realH(303),
          decoration: BoxDecoration(
            color: Color(0xFFFFD59D),
            borderRadius: new BorderRadius.circular(7.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(color: Color(0xFFFFD59D), width: 1),
            borderRadius: new BorderRadius.circular(7.0),
          ),
          margin: EdgeInsets.only(left: 20, right: 20, top: 0),
          padding: EdgeInsets.only(left: 20, right: 20, top: 34),
          width: s.realW(360),
          height: s.realH(303),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP1_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP1_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP2_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP2_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP3_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP3_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP4_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP4_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP5_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP5_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: Lang.JIAMENG_TIP6_LEFT,
                        style:
                            TextStyle(color: Color(0xffAF8DD5), fontSize: 15),
                      ),
                      TextSpan(
                        text: Lang.JIAMENG_TIP6_RIGHT,
                        style:
                            TextStyle(color: Color(0xff2A2A2A), fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  //跳转到我的代理
                  Navigator.of(viewService.context).pushNamed('UniverdalPage');
                },
                child: Container(
                    alignment: Alignment.center,
                    width: s.realW(360),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFFE150),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      alignment: Alignment.center,
                      width: s.realW(268),
                      height: s.realH(36),
                      child: Text(
                        Lang.WODEDAILI,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )),
              ))
            ],
          ),
        )
      ],
    ),
  );
  return Scaffold(
    appBar: appBar,
    body: SafeArea(
      child: Container(
        width: i360,
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  bgW,
                  // kuangW,
                  qrW,
                  yaoqingW,
                  titleW,
                  btnsW,
                  tuiguagnRuleW,
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        promote,
                        Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            addGroup,
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: s.realH(39)),
                                    width: s.realW(204),
                                    height: s.realH(48),
                                    child: Image.asset(ImgCfg.ADD_GROUP_BG,
                                        fit: BoxFit.cover),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: s.realH(39)),
                                    width: s.realW(204),
                                    height: s.realH(48),
                                    child: Text(
                                      Lang.JIAMENGDAILI,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: 50,
                        )

                        // step3C1W
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
