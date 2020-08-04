import 'dart:async';
import 'dart:io';

import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/player/video_page/action.dart';
import 'package:app/player/video_page/video_element.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    VideoComState state, Dispatch dispatch, ViewService viewService) {
  var tapCallBack = (_showUi) {
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
    if (_showUi == null) {
      //如果之前是关闭状态，现在打开，并开启定时器
      if (!state.isShowVideoTopUi) {
        aotuHideTimer = Timer(Duration(seconds: 7), () {
          dispatch(VideoComActionCreator.onShowVideoTopUi(false));
        });
        dispatch(VideoComActionCreator.onShowVideoTopUi(true));
      } else {
        dispatch(VideoComActionCreator.onShowVideoTopUi(false));
      }
    } else {
      if (_showUi) {
        aotuHideTimer = Timer(Duration(seconds: 7), () {
          dispatch(VideoComActionCreator.onShowVideoTopUi(false));
        });
        dispatch(VideoComActionCreator.onShowVideoTopUi(true));
      } else {
        dispatch(VideoComActionCreator.onShowVideoTopUi(false));
      }
    }
  };
  return Container(
    color: Colors.black,
    width: MediaQuery.of(viewService.context).size.width,
    child: Stack(alignment: Alignment.topCenter, children: <Widget>[
      VideoElement(
        state.videoUrl,
        tapCallBack: tapCallBack,
        key: state.globalKey,
        updateCallBack: state.updateCallBack,
        playedSeconds: state.playedTime,
        fullScreenTopUi: buildFullScreenTopUi(state, dispatch, viewService),
      ),
      state.isShowVideoTopUi
          ? buildVideoTopUi(state, dispatch, viewService)
          : Container(),
      //顶部vip，付费按钮去掉
      // (state.isShowVideoTopUi && !state.canWatch && state.reason != 1)
      //     ? buildVipPayBtn(state, dispatch, viewService, () {
      //         dispatch(VideoActionCreator.showVideoDialogAction(
      //             state.reason, state.price, state.wallet));
      //       })
      //     : Container(),
      state.canWatch ? Container() : buildTips(state, dispatch, viewService)
    ]),
  );
}

Widget buildTips(
    VideoComState state, Dispatch dispatch, ViewService viewService) {
  //vip
  if (state.reason == 2) {
    return Positioned(
      top: 28.0,
      child: Text(
        'VIP專享視頻可免費觀看2分鐘',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
  //付费
  if (state.reason == 3) {
    return Positioned(
      top: 28.0,
      child: Text(
        '付費視頻可免費觀看2分鐘',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
  return Container();
}

Widget buildFullScreenTopUi(
    VideoComState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    children: <Widget>[
      Positioned(
        left: 4.0,
        top: (Platform.operatingSystem != "ios") ? 24.0 : 40.0,
        child: GestureDetector(
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          },
          child: Container(
            width: 35,
            height: 35,
            color: Color(0x11010001),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ),
      (!state.canWatch && state.reason != 1)
          ? buildVipPayBtn(
              state,
              dispatch,
              viewService,
              () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                dispatch(VideoActionCreator.showVideoDialogAction(
                    state.reason, state.price, state.wallet));
              },
              top: (Platform.operatingSystem != "ios") ? 30.0 : 46.0,
            )
          : Container(),
    ],
  );
}

Widget buildVideoTopUi(
    VideoComState state, Dispatch dispatch, ViewService viewService) {
  return Positioned(
    left: 4.0,
    top: 12.0,
    child: GestureDetector(
      onTap: () {
        Navigator.pop(viewService.context);
      },
      child: Container(
        width: 35,
        height: 35,
        color: Color(0x11010001),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    ),
  );
}

getBtnDesc(VideoComState state) {
  if (state.reason == 2) return Lang.DIALOG_GOUMAI;
  if (state.reason == 3) return Lang.GOUMAIBENPIAN;
  return "";
}

Widget buildVipPayBtn(VideoComState state, Dispatch dispatch,
    ViewService viewService, Function onTap,
    {right, top}) {
  return Positioned(
    right: right ?? 16.0,
    top: top ?? 16.0,
    child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      GestureDetector(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: SvgPicture.asset(
                ImgCfg.COMMON_BTN1,
                width: Dimens.pt66,
              ),
            ),
            Positioned(
              child: Container(
                width: Dimens.pt66,
                child: Text(
                  getBtnDesc(state),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 18 / 12,
                    color: c.c2,
                  ),
                ),
              ),
            )
          ],
        ),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
      ),
    ]),
  );
}
