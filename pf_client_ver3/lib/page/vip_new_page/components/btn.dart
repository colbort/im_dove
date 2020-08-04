import 'package:flutter/material.dart';

Widget vipBtn({Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 90),
      decoration: BoxDecoration(
          color: Color(0xffFFE150),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 4.0),
              blurRadius: 8.0,
            ),
          ]),
      child: Text(
        '立即购买',
        style: TextStyle(fontSize: 20, color: Color(0xff9A0A0A)),
      ),
    ),
  );
}
