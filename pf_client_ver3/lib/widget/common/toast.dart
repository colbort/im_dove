import 'package:app/config/image_cfg.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'toast/oktoast.dart';

const _dur = Duration(seconds: 2);
const _pos = ToastPosition.top;

enum ToastType { negative, normal, positive }

ToastFuture showToast(String text, {var type = ToastType.normal}) {
  vibrate();
  return showToastWidget(
    Stack(
      alignment: Alignment.center,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.17),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  // spreadRadius: 10.0
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0 + 56 + 4, 10, 20, 10),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: const Color(0xff363636),
                ),
              ),
            )),
        Positioned(
          left: 10,
          child: SvgPicture.asset(
            type == ToastType.normal
                ? ImgCfg.TOAST_NORMAL
                : type == ToastType.positive
                    ? ImgCfg.TOAST_POSITIVE
                    : ImgCfg.TOAST_NEGATIVE,
            width: 56,
            height: 59,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),

    position: _pos,
    duration: _dur,
    // VoidCallback onDismiss,
    // bool dismissOtherToast,
    // TextDirection textDirection,
    // bool handleTouch,
  );
}
