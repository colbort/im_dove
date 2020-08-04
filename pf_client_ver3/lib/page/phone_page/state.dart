import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:app/global_store/state.dart';

enum PhoneStateType {
  none, // 空
  bindPhone, //  绑定手机号
  switchAccount, //  切换账号
  switchPhone, //  更换手机号
}

class PhoneState implements GlobalBaseState, Cloneable<PhoneState> {
  Color themeColor;
  bool didLogin;
  bool showLeading;
  String oldPhone;

  PhoneStateType type;
  String captchaId;
  Timer timer;
  int countdown = -1;

  TextEditingController areaController;
  TextEditingController phoneController;
  TextEditingController captchaController;
  TextEditingController inviteCodeController;

  FocusNode areaNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode captchaNode = FocusNode();
  FocusNode inviteCodeNode = FocusNode();

  @override
  PhoneState clone() {
    return PhoneState()
      ..themeColor = themeColor
      ..didLogin = didLogin
      ..type = type
      ..captchaId = captchaId
      ..timer = timer
      ..countdown = countdown
      ..areaController = areaController
      ..phoneController = phoneController
      ..captchaController = captchaController
      ..inviteCodeController = inviteCodeController
      ..areaNode = areaNode
      ..phoneNode = phoneNode
      ..captchaNode = captchaNode
      ..inviteCodeNode = inviteCodeNode
      ..showLeading = showLeading
      ..oldPhone = oldPhone;
  }
}

PhoneState initState(Map<String, dynamic> args) {
  return PhoneState()
    ..type = PhoneStateType.none
    ..areaController = TextEditingController(text: '+86')
    ..phoneController = TextEditingController()
    ..captchaController = TextEditingController()
    ..inviteCodeController = TextEditingController()
    ..oldPhone = args == null ? '' : args['oldPhone']
    ..showLeading = (args == null || args['showLeading'] == null)
        ? true
        : args['showLeading'];
}
