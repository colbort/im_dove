import 'dart:async';

import 'package:app/global_store/action.dart';
import 'package:app/global_store/store.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_mine_page/effect.dart';
import 'package:app/page/set_page/action.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'package:app/event/index.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<PhoneState> buildEffect() {
  return combineEffects(<Object, Effect<PhoneState>>{
    PhoneAction.onMobileAction: _onMobileAction,
    PhoneAction.onGetCaptcha: _onGetCaptcha,
    PhoneAction.onBind: _onBind,
    PhoneAction.createTimer: _createTimer,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _onMobileAction(Action action, Context<PhoneState> ctx) async {
  String areaCode = action.payload['areaCode'];
  String phoneNum = action.payload['phoneNum'];

  var result = await net.request(Routers.USER_MOBILE_ACTION, args: {
    'mobile': areaCode + phoneNum,
  });
  bool success = result.code == 200 ? true : false;

  if (result.code == 6017) {
    //  binded mobile
    showToast(Lang.OPER_BINDED_MOBILE, type: ToastType.negative);
    return;
  }

  PhoneStateType type;
  if (success) {
    int action = result.data['mobileAction'];
    switch (action) {
      case 1:
        type = PhoneStateType.switchAccount;
        break;
      case 2:
        type = PhoneStateType.bindPhone;
        break;
      case 4:
        type = PhoneStateType.switchPhone;
        break;
      default:
        type = PhoneStateType.none;
        break;
    }
  }
  ctx.dispatch(PhoneActionCreator.mobileAction(type));
}

void _onGetCaptcha(Action action, Context<PhoneState> ctx) async {
  String areaCode = action.payload['areaCode'];
  String phoneNum = action.payload['phoneNum'];

  var result = await net.request(
    Routers.USER_CAPTCHA,
    args: {
      'mobile': areaCode + phoneNum,
    },
  );
  bool success = result.code == 200 && result.data['id'] != null ? true : false;

  if (success) {
    var captchaId = result.data['id'];
    ctx.dispatch(PhoneActionCreator.getCaptcha(captchaId));
    ctx.dispatch(PhoneActionCreator.createTimer());
  }
  var flag = success || result.code == 4002;
  showToast(flag ? Lang.GETCODE_SUC : Lang.GETCODE_FAIL,
      type: flag ? ToastType.positive : ToastType.negative);
}

void _onBind(Action action, Context<PhoneState> ctx) async {
  String areaCode = action.payload['areaCode'];
  String phoneNum = action.payload['phoneNum'];
  String captcha = action.payload['captcha'];
  String inviteCode = action.payload['inviteCode'];

  PhoneState state = ctx.state;

  if (state.showLeading) {
    var result = await net.request(Routers.USER_BIND, args: {
      'mobile': areaCode + phoneNum,
      'captchaId': state.captchaId,
      'captcha': captcha,
      'inviteCode': inviteCode,
    });
    bool success = result.code == 200 ? true : false;
    _didOperateMobile(success, ctx);
  } else {
    var result = await net.request(
      Routers.USER_RELOGIN,
      args: {
        'mobile': areaCode + phoneNum,
        'captchaId': state.captchaId,
        'captcha': captcha,
      },
    );
    bool success = result.code == 200 ? true : false;
    if (success) {
      // await ls.save(StorageKeys.TOKEN, result.data['token']);
      await setToken(result.data['token']);
    }
    _didOperateMobile(success, ctx);
  }
}

void _initState(Action action, Context<PhoneState> ctx) {
  // PhoneState state = ctx.state;
}

void _dispose(Action action, Context<PhoneState> ctx) {
  isHanderingRelogin = false;
  PhoneState state = ctx.state;
  if (state.timer != null && state.timer.isActive) {
    state.timer.cancel();
  }
}

void _createTimer(Action action, Context<PhoneState> ctx) {
  final PhoneState state = ctx.state;
  if (state.timer != null && state.timer.isActive) {
    state.timer.cancel();
  }
  state.countdown = 60;
  state.timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    ctx.dispatch(PhoneActionCreator.scheduleTimer(timer));
  });
}

/// 切换、绑定、更换回调
void _didOperateMobile(bool success, Context<PhoneState> ctx) async {
  print(ctx.state.phoneController);
  if (success) {
    ctx.broadcast(
        SetPageActionCreator.onChangePhone(ctx.state.phoneController.text));
    updateUserInfo.fire(null);
    GlobalStore.store.dispatch(GlobalActionCreator.didLogin());
  }

  //  操作成功1秒后返回上一级
  if (success) {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(ctx.context).pop();
    updateUserInfo.fire(null);
  }
  showToast(success ? Lang.OPER_SUC : Lang.OPER_FAIL,
      type: success ? ToastType.positive : ToastType.negative);
}
