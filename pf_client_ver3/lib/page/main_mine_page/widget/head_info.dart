import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/screen.dart';
import 'package:app/image_cache/cached_network_image.dart';
import '../state.dart';

Widget headInfo(context, MainMineState state) {
  double _w100 = MediaQuery.of(context).size.width;
  Color defaultColor = Color(0Xfff9d44f);
  // int _vipTime = state.vipExpireDate != null
  //     ? DateTime.parse(state.vipExpireDate).microsecondsSinceEpoch
  //     : 0;
  // int _nowTime = DateTime.now().millisecondsSinceEpoch;

  List _recordList = [
    {
      'label': Lang.AVCISHU,
      'value':
          state.totalWatch == -1 ? Lang.WUXIAN : state.avWatchRemain.toString()
    },
    {
      'label': Lang.DUANSHIPINCISHU,
      'value': state.totalWatch == -1
          ? Lang.WUXIAN
          : state.shortWatchRemain.toString()
    },
    {'label': Lang.TUIGUANGRENSHU, 'value': state.promotion.toString()},
  ];

  Widget _recordInfo() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ..._recordList.map((f) {
            return Column(
              children: <Widget>[
                Container(
                    height: 36,
                    child: Center(
                        child: Text(
                      f['value'].toString(),
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                    ))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(f['label'], style: TextStyle(fontSize: 12)),
                )
              ],
            );
          })
        ]);
  }

  return ClipRRect(
    // borderRadius: const BorderRadius.only(
    //   topRight: const Radius.circular(350),
    // ),
    child: Container(
      // alignment: Alignment.topCenter,
      constraints: BoxConstraints.tightFor(
        width: _w100,
      ),
      child: Padding(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                    ),
                    Text(
                      state.nickName != null ? state.nickName : "",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    state.gender == 1
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
                          ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                ),
                getVipExpireState() != 0
                    ? Container(
                        height: s.realH(20),
                        child: Text(
                          "VIP到期:" + showVipDateDesc(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(
                        height: s.realH(20),
                      ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                Widget>[
              Stack(
                //头像
                children: <Widget>[
                  Positioned(
                      left: 8,
                      top: 8,
                      child: state.logo == '' || state.logo == null
                          ? SvgPicture.asset(
                              'assets/mine/default_man.svg',
                              width: s.realW(65),
                              height: s.realW(65),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(s.realW(65)),
                              child: CachedNetworkImage(
                                imageUrl: state.logo,
                                cacheManager: ImgCacheMgr(),
                                width: s.realW(65),
                                height: s.realW(65),
                                fit: BoxFit.cover,
                              ),
                            )),
                  Image(
                    image: state.level == 0
                        ? AssetImage('assets/mine/circle.png')
                        : state.level == 2
                            ? AssetImage('assets/mine/vip_1.png')
                            : state.level == 3
                                ? AssetImage('assets/mine/vip_2.png')
                                : state.level == 4
                                    ? AssetImage('assets/mine/vip_3.png')
                                    : state.level == 1
                                        ? AssetImage('assets/mine/circle.png')
                                        : AssetImage('assets/mine/circle.png'),
                    fit: BoxFit.fill,
                    width: s.realW(75),
                    height: state.level == 0 || state.level == 1
                        ? s.realW(75)
                        : s.realW(85),
                  ),
                ],
              ),
              Container(
                //登陆按钮
                child: Row(
                  children: <Widget>[
                    ButtonTheme(
                        minWidth: 90.0,
                        height: 30.0,
                        child: FlatButton(
                          color: defaultColor,
                          highlightColor: defaultColor,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text(
                            state.mobile != ''
                                ? Lang.BIANJIZILIAO
                                : Lang.DENGRU,
                            style: TextStyle(color: Colors.black),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
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
                        )),
                    Icon(Icons.arrow_right)
                  ],
                ),
              )
            ]),
            Column(
              //观影次数
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: _recordInfo(),
                  margin: EdgeInsets.only(top: s.realH(15)),
                )
              ],
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 0),
      ),
    ),
  );
}
