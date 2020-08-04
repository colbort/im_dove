//CLASS: 进度管理
import 'time_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class ProgressCalculator {
  DragStartDetails startDetails;
  VideoPlayerValue info;

  double dx;

  ProgressCalculator(this.startDetails, this.info);

  static double endTarget = 0;

  //FUNC获取滑动显示时间字符串
  String calcSeek(DragUpdateDetails details, {bool isFull = false}) {
    dx = isFull
        ? details.globalPosition.dy - startDetails.globalPosition.dy
        : details.globalPosition.dx - startDetails.globalPosition.dx;
    var offset = getOffsetPosition().round();
    var total;
    if (endTarget == 0 || endTarget > info.duration.inSeconds) {
      total = offset + info.position.inSeconds;
    } else {
      total = offset + endTarget;
    }
    if (total < 0) {
      total = 0;
    }
    return TimeHelper.getTimeText(total.toDouble());
  }

  //FUNC获取当前播放位置
  double getTargetSeek(DragEndDetails details) {
    if (info == null || info.position == null) return 0;
    var target;
    if (endTarget == 0 || endTarget > info.duration.inSeconds) {
      target = info.position.inSeconds + getOffsetPosition();
    } else {
      target = getOffsetPosition() + endTarget;
    }
    if (target < 0) {
      target = 0.0;
    } else if (target > info.duration.inSeconds.toDouble()) {
      target = info.duration.inSeconds.toDouble();
    }
    endTarget = target + 0.0;
    return target;
  }

  double getOffsetPosition() {
    return dx / 1;
  }
}
