import 'package:flutter/material.dart';

Widget tabBarItem(String title,
    {bool showRightImage = true, int portfolioNum = 0}) {
  return Tab(
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                '$title($portfolioNum)',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
