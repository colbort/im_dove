import 'package:app/config/image_cfg.dart';
import 'package:app/lang/lang.dart';
import 'package:flutter/material.dart';

enum DefaultType { noNetwork, noData, loadFailed }

const double _boxMarginTop = 50;
const double _subMarginTop = 30;
// const double _boxWidth = 142;
// const double _boxHeight = 159;

Widget showDefaultWidget(DefaultType defaultType) {
  return Padding(
    padding: const EdgeInsets.only(top: _boxMarginTop),
    child: Column(
      children: <Widget>[
        Image(
          image: AssetImage(defaultType == DefaultType.noData
              ? ImgCfg.COMMON_NODATA
              : defaultType == DefaultType.loadFailed
                  ? ImgCfg.COMMON_LOADFAILD
                  : ImgCfg.COMMON_NOWIFI),
          // width: _boxWidth,
          // height: _boxHeight,
        ),
        Padding(
          padding: const EdgeInsets.only(top: _subMarginTop),
          child: Text(
            defaultType == DefaultType.noData
                ? Lang.NO_DATA
                : defaultType == DefaultType.loadFailed
                    ? Lang.LOAD_FAILED
                    : Lang.NO_NET,
            style: const TextStyle(
                color: const Color(0xff999999),
                fontSize: 15,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    ),
  );
}
