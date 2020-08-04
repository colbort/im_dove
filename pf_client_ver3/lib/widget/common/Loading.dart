import 'package:app/net/net.dart';
import 'package:app/widget/common/toast/oktoast.dart';
import 'package:flutter/material.dart';

ToastFuture showLoading({double offset = 0.0}) {
  return showToastWidget(
    new CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffffEe03c))),
    position: ToastPosition(align: Alignment.center, offset: offset),
    duration: Duration(milliseconds: timeout),
    // VoidCallback   ,
    // bool dismissOtherToast,
    // TextDirection textDirection,
    // bool handleTouch,
  );
}
