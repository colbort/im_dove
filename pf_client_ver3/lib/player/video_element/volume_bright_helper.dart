import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/utils/native.dart';
import 'package:flutter/material.dart';

Future<double> getVolume(CustomVideoController controller) async {
  return controller.value.volume;
}

double getCurVolume() {
  return curVolume;
}

double curVolume = 100;
//FUNC:放大音量
Future<void> volume(CustomVideoController controller, double dy) async {
  var volume = await getVolume(controller);
  volume += 0.01 * dy;
  volume = volume >= 100.0 ? 100.0 : volume;
  volume = volume <= 0.0 ? 0.0 : volume;
  curVolume = volume;
  controller.setVolume(volume);
}

Future<List> volumeBrightInfo(bool leftVerticalDrag, DragUpdateDetails details,
    CustomVideoController controller) async {
  String text = "";
  IconData iconData = Icons.volume_up;
  //MARK:-只修改音量
  if (leftVerticalDrag == false) {
    //MARK:音量控制
    await volume(controller, -details.delta.dy);

    var currentVolume = await getVolume(controller);

    if (currentVolume <= 0) {
      iconData = Icons.volume_mute;
    } else if (currentVolume < 0.5) {
      iconData = Icons.volume_down;
    } else {
      iconData = Icons.volume_up;
    }

    text = (currentVolume * 100).toStringAsFixed(0);
  } else if (leftVerticalDrag == true) {
    //MARK:亮度控制
    var currentBright = await n.getSystemBrightness();
    double target;
    target = currentBright - 0.01 * details.delta.dy;

    if (target > 1) {
      target = 1;
    } else if (target < 0) {
      target = 0;
    }

    await n.setSystemBrightness(target);

    if (target >= 0.66) {
      iconData = Icons.brightness_high;
    } else if (target < 0.66 && target > 0.33) {
      iconData = Icons.brightness_medium;
    } else {
      iconData = Icons.brightness_low;
    }

    text = (target * 100).toStringAsFixed(0);
  } else {
    return null;
  }
  return [text, iconData];
}
