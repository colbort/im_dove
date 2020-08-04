import 'dart:async';
import 'package:app/event/index.dart';
import 'package:app/page/main_mine_page/effect.dart';
import 'package:app/page/main_pao_page/page.dart';
import 'package:app/page/recommend_page/page.dart';
import 'package:app/page/update_page/page.dart';
import 'package:app/player/preview_player/preview_player_ctrl.dart';
import 'package:app/utils/version.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:app/lang/lang.dart';
import 'package:flutter_svg/svg.dart';

import 'action.dart';
import 'state.dart';
import 'package:app/config/image_cfg.dart';

import '../main_mine_page/page.dart';
import '../main_av_page/page.dart';

final _indexedStack = <Widget>[
  RecommendPage().buildPage(null),
  MainPaoPage().buildPage(null),
  MainAvPage().buildPage(null),
  MainMinePage().buildPage(null),
];
const _bottomNavigationColor = Colors.black;

DateTime _lastPressedAt; //上次点击时间
Timer getInfoTimer;

Widget buildView(MainState state, Dispatch dispatch, ViewService viewService) {
  if (state.showUpdater &&
      version.needUpdate &&
      isResumed &&
      !version.isForceUpdate) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {showUpdatePage(viewService.context)});
    dispatch(MainActionCreator.onShowUpdater(false));
  }
  // DateTime _lastPressedAt; //上次点击时间
  return Scaffold(
    body: WillPopScope(
        onWillPop: () async {
          if (state.isAlowedBackApp) {
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt) >
                    Duration(seconds: 2)) {
              //两次点击间隔超过1秒则重新计时
              _lastPressedAt = DateTime.now();
              showToast(Lang.BACK_APP_TIP, type: ToastType.normal);
              return false;
            }
            return true;
          } else {
            return true;
          }
        },
        child: IndexedStack(
          children: _indexedStack,
          index: state.index,
        )),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
            icon: const Image(
              image: const AssetImage(ImgCfg.MAIN_HOME),
              width: 30,
              height: 30,
            ),
            activeIcon: const Image(
              image: const AssetImage(ImgCfg.MAIN_HOME_SEL),
              width: 30,
              height: 30,
            ),
            title: const Text(
              Lang.SHOUYE,
              style: const TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImgCfg.MAIN_PAO_NORMAL,
              width: 30,
              height: 30,
            ),
            activeIcon: SvgPicture.asset(
              ImgCfg.MAIN_PAO_SEL,
              width: 30,
              height: 30,
            ),
            title: const Text(
              Lang.PAOBA,
              style: const TextStyle(color: _bottomNavigationColor),
            )),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImgCfg.AV_NORMAL,
              width: 30,
              height: 30,
            ),
            activeIcon: SvgPicture.asset(
              ImgCfg.AV_SEL,
              width: 30,
              height: 30,
            ),
            title: const Text(
              'AV',
              style: const TextStyle(color: _bottomNavigationColor),
            )),
        const BottomNavigationBarItem(
            icon: const Image(
              image: const AssetImage(ImgCfg.MAIN_MIME),
              width: 30,
              height: 30,
            ),
            activeIcon: const Image(
              image: const AssetImage(ImgCfg.MAIN_MIME_SEL),
              width: 30,
              height: 30,
            ),
            title: const Text(
              Lang.WODE,
              style: const TextStyle(color: _bottomNavigationColor),
            )),
      ],
      currentIndex: state.index,
      onTap: (int index) {
        if (index == state.index) {
          return;
        }
        //底部导航栏切换的时候，释放预览视频播放器

        disposeCurCtrl();
        if (index == 4) {
          getInfoTimer?.cancel();
          getInfoTimer = Timer.periodic(Duration(milliseconds: 30 * 1000), (e) {
            updateUserInfo.fire(null);
          });
        } else {
          getInfoTimer?.cancel();
        }
        viewService.broadcast(MainActionCreator.onSwitchIndexAction(index));
      },
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
