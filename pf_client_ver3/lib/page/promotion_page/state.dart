import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class PromotionState implements Cloneable<PromotionState> {
  /// 邀请码
  String inviteCode;

  /// 分享地址
  String url;
  GlobalKey pipCaptureKey = GlobalKey();

  @override
  PromotionState clone() {
    return PromotionState()
      ..inviteCode = inviteCode
      ..url = url
      ..pipCaptureKey = pipCaptureKey;
  }
}

PromotionState initState(Map<String, dynamic> args) {
  return PromotionState();
}
