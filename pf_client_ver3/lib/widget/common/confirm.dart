import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';

import '../../utils/utils.dart';

final _i40 = s.realW(40);
final _i20 = s.realW(20);
final _i200 = s.realW(200);
final _h32 = s.realH(35);

Future<bool> showConfirmSimple({String title, Widget child, bool hasCancel = false}) {
  return showConfirm(getAppContext(),
      title: title, child: child, hasCancel: hasCancel);
}

/// 使用事例：
/// [return] 确认返回 true, 点击取消与点击背景返回 false
/// ```dart
/// bool ok = await showConfirm(...)
/// if(ok){
///   print('点击了确认！')
/// }else{
///   print('点击了取消！')
/// }
/// ```
Future<bool> showConfirm(BuildContext context,
    {String title, Widget child, bool hasCancel = false}) async {
  var res = await showDialog<bool>(
    context: context,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: _i40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: _i20),
                    child: title != null
                        ? Text(title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ))
                        : Container(),
                  ),
                  Padding(
                      padding: EdgeInsets.all(_i20),
                      child: Material(
                        color: Colors.white,
                        child: child != null ? child : Container(),
                      )),
                  hasCancel
                      ? Container(
                          height: 1.0,
                          color: Color.fromRGBO(25, 25, 25, 0.2),
                          width: double.infinity,
                        )
                      : Container(),
                  hasCancel ? _okCancelBuild(context) : _okBuild(context)
                ],
              ),
            )
          ],
        ),
      );
    },
  );
  return res == null ? false : res;
}

Widget _splitLine() {
  return Container(
    width: 1.0,
    color: Color.fromRGBO(25, 25, 25, 0.2),
    height: 19,
  );
}

Widget _okCancelBuild(BuildContext context) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
            width: s.realW(135),
            height: 40,
            alignment: Alignment.center,
            child: Text(
              Lang.QUXIAO,
              style: TextStyle(fontSize: 16, color: Color(0xff363636)),
            ),
          ),
        ),
        _splitLine(),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Container(
            width: s.realW(135),
            height: 40,
            alignment: Alignment.center,
            child: Text(
              Lang.QUEDING,
              style: TextStyle(fontSize: 16, color: Color(0xff57aaff)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _okBuild(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop(true);
    },
    child: Material(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(bottom: _i20),
        constraints: BoxConstraints.tightFor(width: _i200, height: _h32),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), color: Color(0xffff5b6f)),
        child: Center(
          child: Text(
            Lang.QUEREN,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
