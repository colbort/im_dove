import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

Widget rowItem(
    SvgPicture icon, String name, bool isShowBorder, Function tapHandle) {
  var w = MediaQueryData.fromWindow(ui.window).size.width;
  return GestureDetector(
      onTap: tapHandle,
      child: Container(
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: isShowBorder == true
        //         ? Border(
        //             bottom: BorderSide(
        //             color: Color(0xffdddddd),
        //             width: 1.0,
        //           ))
        //         : Border()),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 52),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          icon,
                          Container(
                            width: w - 150,
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              name,
                              style: TextStyle(
                                  color: Color(0Xff454545), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ],
              )),
        ),
      ));
}

Widget rowItemEx(Widget icon, String name, bool isShowBorder,
    Function tapHandle, Widget rightW) {
  var w = MediaQueryData.fromWindow(ui.window).size.width;
  return GestureDetector(
      onTap: tapHandle,
      child: Container(
        // color: Colors.blue,
        width: w,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 52),
          child: Container(
            height: s.realH(52),
            // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: s.realW(22),
                      height: s.realH(22),
                      child: Center(
                        child: icon,
                      ),
                    ),
                    Container(
                      width: w - 200,
                      margin: EdgeInsets.only(
                          left: s.realW(
                            10,
                          ),
                          bottom: s.realH(3)),
                      child: Text(
                        name,
                        style:
                            TextStyle(color: Color(0Xff333333), fontSize: 16),
                      ),
                    ),
                  ],
                ),
                rightW
              ],
            ),
          ),
        ),
      ));
}
