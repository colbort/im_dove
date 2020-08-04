import 'package:flutter/material.dart';

Widget commonBtn(String text, {double marginTop, Function tabHandle}) {
  return GestureDetector(
    onTap: tabHandle,
    child: Container(
      margin: EdgeInsets.only(top: marginTop),
      decoration: BoxDecoration(
        color: Color(0xffff5b6f),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.17),
            offset: Offset(0.0, 4.0),
            blurRadius: 10.0,
            // spreadRadius: 10.0
          ),
        ],
      ),
      constraints: const BoxConstraints.tightFor(width: 307, height: 37),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
