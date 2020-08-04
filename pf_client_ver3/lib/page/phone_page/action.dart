import 'dart:async';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/page/phone_page/state.dart';

enum PhoneAction {
  action,
  onMobileAction, //  获取动作
  mobileAction, // 获取动作后处理
  onGetCaptcha, //  获取验证码
  getCaptcha,
  onBind, //  绑定手机号
  createTimer,
  scheduleTimer,
}

class PhoneActionCreator {
  static Action onAction() {
    return const Action(PhoneAction.action);
  }

  static Action onMobileAction(String areaCode, String phoneNum) {
    return Action(PhoneAction.onMobileAction, payload: {
      'areaCode': areaCode,
      'phoneNum': phoneNum,
    });
  }

  static Action mobileAction(PhoneStateType type) {
    return Action(PhoneAction.mobileAction, payload: {
      'type': type,
    });
  }

  static Action onGetCaptcha(String areaCode, String phoneNum) {
    return Action(PhoneAction.onGetCaptcha,
        payload: {'areaCode': areaCode, 'phoneNum': phoneNum});
  }

  static Action onBind(
      String areaCode, String phoneNum, String captcha, String inviteCode) {
    return Action(PhoneAction.onBind, payload: {
      'areaCode': areaCode,
      'phoneNum': phoneNum,
      'captcha': captcha,
      'inviteCode': inviteCode
    });
  }

  static Action getCaptcha(String captchaId) {
    return Action(PhoneAction.getCaptcha, payload: {
      'captchaId': captchaId,
    });
  }

  static Action createTimer() {
    return Action(PhoneAction.createTimer);
  }

  static Action scheduleTimer(Timer timer) {
    return Action(PhoneAction.scheduleTimer);
  }
}
