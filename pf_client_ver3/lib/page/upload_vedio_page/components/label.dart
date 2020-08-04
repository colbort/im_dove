import 'package:app/config/image_cfg.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

Widget homeLabel({String text = '', String subtitle = '', Function onTap}) {
  return Padding(
    padding: EdgeInsets.only(top: 20, left: s.realW(12), bottom: 10),
    child: Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              bottom: -3,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffffe300),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                width: (text.length * 20).toDouble(),
                height: 12,
              ),
            ),
            Container(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: s.realW(15)),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget tipLabel({String text = '', String subtitle = '', Function onTap}) {
  return Padding(
    padding: EdgeInsets.only(top: 20, left: s.realW(12), bottom: 10),
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 7),
          width: s.realW(4),
          height: s.realH(19),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(s.realW(4)),
                ),
                color: Color.fromRGBO(250, 221, 45, 1)),
          ),
        ),
        Container(
          // color: Colors.red,
          child: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Container(
          // color: Colors.red,
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
            ),
          ),
        )),
        onTap != null
            ? InkWell(
                child: Image(
                  image: AssetImage(ImgCfg.COMMON_ARROW_RIGHT),
                  width: s.realW(30),
                ),
                onTap: onTap)
            : Container(),
      ],
    ),
  );
}
