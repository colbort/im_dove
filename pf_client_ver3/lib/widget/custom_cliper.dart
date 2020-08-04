import 'dart:core';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

/// 自定贝塞尔曲线义裁剪
class CustomClip extends CustomClipper<Path> {
  // final double radius;
  final List<Math.Point> points;

  CustomClip({this.points});

  /// 角度转弧度公式
  double degree2Radian(int degree) {
    return (Math.pi * degree / 180);
  }

  @override
  Path getClip(Size size) {
    var path = Path();

    if (this.points.length > 0) {
      path.moveTo(this.points[0].x, this.points[0].y); // 此点为多边形的起点
      path.lineTo(this.points[1].x, this.points[1].y);
      for (var i = 2; i < this.points.length - 2;) {
        path.quadraticBezierTo(
            //形成曲线
            this.points[i].x,
            this.points[i].y,
            this.points[i + 1].x,
            this.points[i + 1].y);
        i += 2;
      }
      for (var i = this.points.length - 2; i < this.points.length; i++) {
        path.lineTo(this.points[i].x, this.points[i].y);
      }
    }

    path.close(); // 使这些点构成封闭的多边形

    return path;
  }

  @override
  bool shouldReclip(CustomClip oldClipper) {
    return this.points != oldClipper.points;
  }
}

/// 余弦
/// @param w 宽度
/// @param h 高度
/// @param n 多少哥周期
List<Math.Point<num>> Function(double w, double h, double n) getCosPoints =
    (double w, double h, double n) {
  List<Math.Point> list = [];
  n = 4;

  /// 每个周期
  var k = n * 4;
  var ih = 20;
  var w1 = w / k;
  list.add(Math.Point(0.0, 0.0));
  list.add(Math.Point(0.0, h - ih));

  for (var i = 0; i < k; i++) {
    var x = w1 * (i + 1);
    var y = h;

    y -= i % 2 == 1 ? ih : 0;
    if (i % 4 == 2) y = y - 2 * ih;

    Math.Point p1 = Math.Point(x, y);
    list.add(p1);
  }

  list.add(Math.Point(w, h - ih));
  list.add(Math.Point(w, 0.0));
  // print(list);
  return list;
};
