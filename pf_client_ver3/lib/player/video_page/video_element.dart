import 'dart:async';
import 'package:app/player/video_element/uninitialized_widget.dart';
import 'package:app/player/video_element/video_gesture.dart';
import 'package:app/player/video_element/video_progress_bar.dart';
import 'package:app/player/video_element/volume_bright_helper.dart';
import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class VideoElement extends StatefulWidget {
  VideoElement(
    this.videoUrl, {
    this.title = 'VideoPage',
    this.tapCallBack,
    this.updateCallBack,
    this.fullScreenTopUi,
    this.playedSeconds = 0,
    Key key,
  }) : super(key: key);

  final String title;
  final String videoUrl;
  final TapCallBack tapCallBack;
  final Function(CustomVideoController) updateCallBack;
  final Widget fullScreenTopUi;
  final int playedSeconds;

  @override
  State<StatefulWidget> createState() {
    return _VideoElementState();
  }
}

CustomVideoController controller;

class _VideoElementState extends State<VideoElement>
    with TickerProviderStateMixin {
  int playedSeconds = 0;
  bool showUi = false;
  @override
  void initState() {
    showUi = false;
    playedSeconds = widget.playedSeconds;
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
        controller.setVolume(volume);
        controller.play();
        controller.addListener(controller.listener);
        controller.errCallback = playErr;
        controller.updateCallback = widget.updateCallBack;
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

    if (updateCallback != null) {
      controller.updateCallback = updateCallback;
    }

    if (isFullScreen != null) {
      controller.isFullScreen = isFullScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _aspectRatio = 1.8;
    var _height = _width / _aspectRatio;

    //视频地址变为空了
    if (widget.videoUrl == null || widget.videoUrl.isEmpty) {
      var tmpControl = controller;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tmpControl?.dispose();
      });
      //切换视频
      if (controller != null) {
        playedSeconds = 0;
      }
      controller = null;
    } else {
      //视频切换了 || 视频地址获取到了
      if (controller == null || controller.dataSource != widget.videoUrl) {
        var tmpControl = controller;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tmpControl?.dispose();
        });
        //切换视频
        if (controller != null && controller.dataSource != widget.videoUrl) {
          playedSeconds = 0;
        }
        initControl(
            freshCallback: controller?.freshCallback,
            updateCallback: controller?.updateCallback,
            isFullScreen: controller?.isFullScreen);
      }

      //刷新回调重置了，出现在付费视频付费成功之后
      if (widget.updateCallBack == null &&
          controller != null &&
          controller.updateCallback != null) {
        controller.updateCallback = null;
        if (!controller.value.isPlaying) {
          controller.play();
        }
      }
    }

    if (controller == null) {
      return buildUnInitializedWidget(_width, _height, tapCallBack);
    }

    return CustomVideoPlayer(
      controller: controller,
      progressBar: showUi ? progressBar : null,
      fullScreenProgressBar: fullScreenProgressBar,
      fullScreenTopUi: widget.fullScreenTopUi,
      gestureWidget: gestureWidget,
      tapCallBack: tapCallBack,
      rotateToFullScreen: true,
      width: _width,
      height: _height,
      unInitializedBuilder: buildUnInitializedWidget,
    );
  }

  Widget gestureWidget(ctrl, tapCallback) {
    return PFVideoGesture(
      controller: ctrl,
      tapCallback: tapCallback,
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
            fullScreenIcon: 'assets/player/fullscreen_up.svg',
            controller: ctrl,
            fullScreenDel: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
              ]);
              // _showFullScreenWithRotateBox(context, _controller);
            },
          ),
        ),
      ],
    );
  }

  Widget fullScreenProgressBar(ctrl) {
    return SafeArea(
      left: false,
      right: false,
      top: false,
      child: Row(
        children: <Widget>[
          Expanded(
            child: PFVideoProgressBar(
              playBtn: 'assets/player/play.svg',
              pauseBtn: 'assets/player/pause.svg',
              fullScreenIcon: 'assets/player/fullscreen_down.svg',
              controller: ctrl,
              fullScreenDel: () {
                // Navigator.pop(context);
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
