import 'package:app/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/image_cfg.dart';

class UpdateAnimate extends StatefulWidget {
  UpdateAnimate({
    this.size,
    this.rotation,
    this.path,
    this.updateContorller,
  });

  final double size;
  final int rotation;
  final String path;
  final UpdateContorller updateContorller;
  @override
  _UpdateAnimateState createState() => _UpdateAnimateState();
}

class _UpdateAnimateState extends State<UpdateAnimate>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  double _size;
  int _ration;
  String _path;

  void start() {
    controller.forward(from: 0.0);
  }

  void stop() {
    controller.stop();
  }

  @override
  void initState() {
    super.initState();
    widget.updateContorller
      ..start = start
      ..stop = stop;
    _size = widget.size ?? Dimens.pt16;
    _ration = widget.rotation ?? 1500;
    _path = widget.path ?? ImgCfg.COMMON_UPDATE_ANIMATE;
    controller = AnimationController(
      duration: Duration(milliseconds: _ration),
      vsync: this,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        alignment: Alignment.center,
        turns: controller,
        child: Container(
          height: _size,
          width: _size,
          child: SvgPicture.asset(
            _path,
            height: _size,
            width: _size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class UpdateValue {
  UpdateValue({
    this.start,
    this.stop,
  });
  UpdateValue copyWith(Function start, Function stop) {
    return UpdateValue(start: start, stop: stop);
  }

  final Function start;
  final Function stop;
}

class UpdateContorller extends ValueNotifier<UpdateValue> {
  UpdateContorller({Function start, Function stop})
      : super(UpdateValue(start: start, stop: stop));

  Function get start => value.start;
  set start(Function start) => value = value.copyWith(start, value.stop);
  Function get stop => value.stop;
  set stop(Function stop) => value = value.copyWith(value.start, stop);
}
