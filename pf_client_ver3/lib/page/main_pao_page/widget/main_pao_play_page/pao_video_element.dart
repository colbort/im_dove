import 'dart:async';
import 'package:app/player/video_element/uninitialized_widget.dart';
import 'package:app/player/video_element/video_gesture.dart';
import 'package:app/player/video_element/video_progress_bar.dart';
import 'package:app/player/video_element/volume_bright_helper.dart';
import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:video_player/video_player.dart';

class PaoVideoElement extends StatefulWidget {
  PaoVideoElement(
    this.videoUrl, {
    this.title = 'PaoVideoPage',
    this.tapCallBack,
    Key key,
  }) : super(key: key);

  final String title;
  final String videoUrl;
  final TapCallBack tapCallBack;

  @override
  State<StatefulWidget> createState() {
    return _PaoVideoElementState();
  }
}

class _PaoVideoElementState extends State<PaoVideoElement>
    with TickerProviderStateMixin {
  bool showUi = false;
  CustomVideoController controller;
  int playedSeconds = 0;
  @override
  void initState() {
    playedSeconds = 0;
    showUi = false;
    super.initState();
    initControl();
  }

  @override
  void dispose() {
    super.dispose();
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
    controller?.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
    showUi = false;
    if (widget.tapCallBack != null) {
      widget.tapCallBack(false);
    }
  }

  void playErr() {
    if (controller != null) {
      var tmpCtrl = controller;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tmpCtrl.dispose();
      });
      setState(() {});

      if (controller.freshCallback != null &&
          controller.freshCallback is Function) {
        controller.freshCallback(controller);
      }

      playedSeconds = playedSeconds > controller.playedSeconds
          ? playedSeconds
          : controller.playedSeconds;
    }

    initControl(
        freshCallback: controller.freshCallback,
        updateCallback: controller.updateCallback,
        isFullScreen: controller.isFullScreen);
  }

  void initControl({freshCallback, updateCallback, isFullScreen}) {
    if (widget.videoUrl == null || widget.videoUrl.isEmpty) {
      controller = null;
      return;
    }
    controller = CustomVideoController.network(widget.videoUrl,
        formatHint: VideoFormat.hls)
      ..initialize().then((_) {
        setState(() {});
        if (controller.freshCallback != null &&
            controller.freshCallback is Function) {
          controller.freshCallback(controller);
        }

        if (playedSeconds > 0) {
          controller.seekTo(Duration(seconds: playedSeconds));
        }

        var volume = getCurVolume();
        controller.setLooping(true);
        controller.setVolume(volume);
        controller.play();
        controller.addListener(controller.listener);
        controller.errCallback = playErr;
      }, onError: (e) {
        controller?.dispose();
        initControl(
            freshCallback: controller.freshCallback,
            updateCallback: controller.updateCallback,
            isFullScreen: controller.isFullScreen);
      });
    if (freshCallback != null) {
      controller.freshCallback = freshCallback;
    }
    if (isFullScreen != null) {
      controller.isFullScreen = isFullScreen;
    }
  }

  double _width = 0;
  double _height = 0;
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.black12);
    });
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    if (controller == null) {
      return buildUnInitializedWidget(_width, _height, tapCallBack);
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomVideoPlayer(
          controller: controller,
          progressBar: showUi ? progressBar : null,
          gestureWidget: gestureWidget,
          tapCallBack: tapCallBack,
          rotateToFullScreen: false,
          width: _width,
          height: _height,
          unInitializedBuilder: buildUnInitializedWidget,
          isFixWidth: false,
        ),
      ],
    );
  }

  Widget gestureWidget(ctrl, tapCallback) {
    return PFVideoGesture(
      controller: ctrl,
      tapCallback: tapCallback,
      height: _height,
      width: _width,
    );
  }

  Timer aotuHideTimer;
  void tapCallBack(_showUi) {
    if (widget.tapCallBack != null) {
      widget.tapCallBack(_showUi);
    }
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
    setState(() {
      if (_showUi == null) {
        showUi = !showUi;
        if (showUi) {
          aotuHideTimer = Timer(Duration(seconds: 7), () {
            if (mounted) {
              setState(() {
                showUi = false;
              });
            }
          });
        }
      } else {
        showUi = _showUi;
        if (showUi) {
          aotuHideTimer = Timer(Duration(seconds: 7), () {
            if (mounted) {
              setState(() {
                showUi = false;
              });
            }
          });
        }
      }
    });
  }

  Widget progressBar(ctrl) {
    return Row(
      children: <Widget>[
        Expanded(
          child: PFVideoProgressBar(
            playBtn: 'assets/player/play.svg',
            pauseBtn: 'assets/player/pause.svg',
            controller: ctrl,
          ),
        ),
      ],
    );
  }
}
