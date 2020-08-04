import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
// import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../state.dart';

Widget viphead(VipNewState state) {
  // var st = showVipDateDesc();
  // print(st);

  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white),
    padding: EdgeInsets.symmetric(
      vertical: s.realH(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '您當前為',
              style: TextStyle(fontSize: 16, color: Color(0xffFF7600)),
            ),
            Text(
                state.viplevel == 1
                    ? '體驗VIP'
                    : state.viplevel == 2
                        ? '月度VIP'
                        : state.viplevel == 3
                            ? '季度VIP'
                            : state.viplevel == 4 ? '年度VIP' : '',
                style: TextStyle(fontSize: 20, color: Color(0xffFF4651)))
          ],
        ),
        // Text('到期时间：2019.12.30', style: TextStyle(fontSize: 12))
        getVipExpireState() != 0
            ? Text("VIP到期:" + showVipDateDesc(), style: TextStyle(fontSize: 12))
            : Container()
      ],
    ),
  );
}
