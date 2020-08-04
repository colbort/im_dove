import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../widget/common/BasePage.dart';
import '../../widget/common/commWidget.dart';
import 'state.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildView(
    CarDriverState state, Dispatch dispatch, ViewService viewService) {
  return _SetPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _SetPageView extends BasePage with BasicPage {
  final CarDriverState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _SetPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => Lang.KAICHEQUN;

  _launchURL(url, index) async {
    if (await canLaunch(url)) {
      //下载过了 直接打开群链接
      await launch(url);
    } else {
      //下载app
      var isIOS = Platform.operatingSystem == "ios";
      if (isIOS) {
        //ios
        launch(index == 0
            ? "https://apps.apple.com/hk/app/potato-chat/id1214241191?mt=12"
            : index == 1
                ? "https://apps.apple.com/hk/app/telegram/id747648890?mt=12"
                : "");
      } else {
        //android
        launch(index == 0
            ? "https://www.potato.im"
            : index == 1 ? "https://telegram.org" : "");
      }
      throw 'Could not launch $url';
    }
  }

  //MARK:--提交按钮
  Widget _commonBtn(int index, String text, Color color, String url) {
    return GestureDetector(
        onTap: () {
          _launchURL(url, index);
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.17),
                offset: Offset(0.0, 4.0),
                blurRadius: 10.0,
                // spreadRadius: 10.0
              ),
            ],
          ),
          constraints: BoxConstraints.tightFor(width: 164, height: 39),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ));
  }

  Widget item(index, url, {double padding = 20}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        height: 210,
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(top: padding),
              // ),
              SvgPicture.asset(
                index == 0
                    ? "assets/mine/pt.svg"
                    : index == 1 ? "assets/mine/tg.svg" : "assets/mine/lt.svg",
                height: 80,
                width: 80,
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 12),
              // ),
              Text(
                index == 0 ? Lang.POTATO : index == 1 ? Lang.TG : Lang.LT,
                style: TextStyle(
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
              ),
              _commonBtn(index, index == 2 ? Lang.LIJIXIAZAI : Lang.LIJIJIARU,
                  Color(0xFFf9d44f), url),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget body() {
    var _td, _tg, _lt;
    if (state.group != null && state.group.length > 0) {
      _td = state.group.firstWhere((t) => t['type'] == 1);
      _tg = state.group.firstWhere((t) => t['type'] == 2);
      _lt = state.group.firstWhere((t) => t['type'] == 0);
    }
    // print('$_td $_tg $_lt');
    return state.group.isEmpty
        ? Container()
        : Center(
            child: Container(
              color: Color.fromARGB(1, 242, 242, 242),
              child: ListView(
                // physics: NeverScrollableScrollPhysics(),
                // padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    // height: Dimens.pt30,
                    padding: EdgeInsets.symmetric(horizontal: Dimens.pt23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          Lang.PAOYOUFULI,
                          style: TextStyle(
                              color: Color(0xFF6F4C1B),
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Lang.YIJIANJIAQUN,
                          style: TextStyle(
                              color: Color(0xFF363636),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  getHengLine(
                    color: c.cD8D8D8,
                    margin: EdgeInsets.symmetric(horizontal: Dimens.pt23),
                  ),
                  item(0, _td["link"], padding: 0),
                  item(1, _tg["link"], padding: 0),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.pt23),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          Lang.FANGQIANGBIBEI,
                          style: TextStyle(
                              color: Color(0xFF6F4C1B),
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Lang.WUXUDENGDAI,
                          style: TextStyle(
                              color: Color(0xFF363636),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  getHengLine(
                    color: c.cD8D8D8,
                    margin: EdgeInsets.symmetric(horizontal: Dimens.pt23),
                  ),
                  item(2, _lt["link"]),
                ],
              ),
            ),
          );
  }
}
