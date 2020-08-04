import 'package:app/page/notice_page/page.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/version.dart';
import 'package:app/widget/common/toast.dart';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:app/page/main_mine_page/action.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/event/index.dart';
import 'package:app/lang/lang.dart';
import 'package:app/umplus/umplus.dart' as umplus;

Effect<MainState> buildEffect() {
  return combineEffects(<Object, Effect<MainState>>{
    Lifecycle.initState: _initState,
    Lifecycle.didUpdateWidget: _fireUpdate,
    Lifecycle.didUpdateWidget: _updateWigetAction,
    MainAction.onSwitchIndex: _onSwitchIndex,
    MainAction.onSwitchToTopic: _onSwitchToTopic,
    // MainAction.onShowFloatingButton: _onShowFloatingButton,
    // MainAction.onShowFullFloatingActionButton: _onShowFullFloatingActionButton
  });
}

//MARK:--处理状态栏
void _updateWigetAction(Action action, Context<MainState> ctx) {
  bool isShortVideo =
      ctx.state.index == 1 && (!Navigator.of(ctx.context).canPop());
  Future.delayed(Duration(milliseconds: 500), () {
    setStatusBarWhiteText(isShortVideo);
  });
}

// void _onAction(Action action, Context<MainVedioState> ctx) {}
void _initState(Action action, Context<MainState> ctx) async {
  umplus.event(umplus.Events.pvtuiJian, needRecordOperation: false).sendEvent();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  setStatusBarWhiteText(false);
  Future.delayed(Duration(milliseconds: 3000), () {
    setStatusBarWhiteText(true);
  });
  statusBarEvent.on().listen((data) {
    bool isShortVideo =
        ctx.state.index == 1 && (!Navigator.of(ctx.context).canPop());
    Future.delayed(Duration(milliseconds: 500), () {
      setStatusBarWhiteText(isShortVideo);
    });
  });

  mainPageInited = true;
  reLoginEventBus.on().listen((event) async {
    Navigator.of(ctx.context)
        .pushNamed('phone', arguments: {'showLeading': false});
    showToast(Lang.PHONE_RELOGTIPS, type: ToastType.negative);
  });

  isAlowedBackApp.on<bool>().listen((state) {
    ctx.dispatch(MainActionCreator.onSetVideoState(state));
  });
  // showVideoHitEvent.on<ShowVideoHitEvent>().listen((data) {
  //   if (data.type == 9) {
  //     Navigator.of(ctx.context)
  //         .pushNamed('WalletPage', arguments: {'showCharge': true});
  //   }
  // });

  Future.delayed(const Duration(milliseconds: 1500), () {
    if (Navigator.of(ctx.context).canPop()) Navigator.of(ctx.context).pop();
    showNoticePage(ctx.context);
  });
}

_onSwitchIndex(Action action, Context<MainState> ctx) {
  var index = action.payload;
  ctx.dispatch(MainActionCreator.switchIndexAction(index));
  ctx.broadcast(MainActionCreator.switchIndexAction(index));
  setStatusBarWhiteText(index == 1);
  // _recordSwitchIndex(index);
  switch (index) {
    case 0:
      umplus
          .event(umplus.Events.pvtuiJian, needRecordOperation: false)
          .sendEvent();

      // ctx.broadcast(MainHomeActionCreator.onInit());
      break;
    case 1:
      umplus
          .event(umplus.Events.pvyuanChuang, needRecordOperation: false)
          .sendEvent();
      ctx.broadcast(MainActionCreator.onInitVideoPage());
      break;
    case 2:
      umplus.event(umplus.Events.pvaav, needRecordOperation: false).sendEvent();
      // ctx.broadcast(MainAvActionCreator.onInitEffect());
      break;
    case 3:
      umplus
          .event(umplus.Events.pvzhuanTi, needRecordOperation: false)
          .sendEvent();
      ctx.broadcast(MainActionCreator.onInitZTPage());
      break;
    case 4:
      umplus
          .event(umplus.Events.pvwoDe, needRecordOperation: false)
          .sendEvent();
      ctx.broadcast(MainMineActionCreator.getInfo());
      break;
  }
}

_onSwitchToTopic(Action action, Context<MainState> ctx) {
  // final String activeTopicId = action.payload;
  ctx.dispatch(MainActionCreator.onSwitchIndexAction(3));
  // Future.delayed(Duration(milliseconds: 300), () {
  //   ctx.broadcast(MainZTActionCreator.onSwitchTopic(activeTopicId));
  // });
}

_fireUpdate(Action action, Context<MainState> ctx) async {
  if (isResumed) {
    await version.initUpdater();
    ctx.dispatch(MainActionCreator.onShowUpdater(true));
  }
}
