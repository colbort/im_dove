import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:app/utils/logger.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

EventBus ctrlDisposeEvent = EventBus();

class PreViewVideoElement extends StatefulWidget {
  ///控制器, dispose交给上层来释放
  final CustomVideoController controller;

  ///进度条
  final ProgressBuilder progressBar;

  ///全屏进度条
  final ProgressBuilder fullScreenProgressBar;

  ///全屏顶部ui
  final Widget fullScreenTopUi;

  ///手势组件
  final GestureBuilder gestureWidget;

  ///点击屏幕回调
  final TapCallBack tapCallBack;

  ///未初始化以及网络错误情况下的widget
  final UnInitializedWidgetBuilder unInitializedBuilder;

  ///旋转是否全屏
  final bool rotateToFullScreen;

  ///宽度
  final double width;

  ///高度
  final double height;

  ///是否固定宽度,只作用于非全屏模式
  final bool isFixWidth;

  ///dipose状态显示的widget
  final Widget disposedWidget;

  PreViewVideoElement({
    Key key,
    @required this.controller,
    @required this.rotateToFullScreen,
    @required this.width,
    @required this.height,
    @required this.unInitializedBuilder,
    this.progressBar,
    this.gestureWidget,
    this.tapCallBack,
    this.fullScreenProgressBar,
    this.fullScreenTopUi,
    this.isFixWidth = true,
    this.disposedWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PreViewVideoElementState();
  }
}

class _PreViewVideoElementState extends State<PreViewVideoElement>
    with TickerProviderStateMixin {
  bool isManualDisposed = false;
  @override
  void initState() {
    isManualDisposed = false;
    super.initState();
    ctrlDisposeEvent.on().listen((data) {
      if (mounted) {
        log.i("手动释放");
        isManualDisposed = true;
        setState(() {});
      }
    });
    if (widget.controller == null ||
        widget.controller.stype == CustomVideoControllerType.dispose) {
      return;
    }
    widget.controller.initialize().then((_) {
      if (mounted) {
        if (widget.controller != null &&
            widget.controller.stype != CustomVideoControllerType.dispose) {
          widget.controller.setVolume(0);
          widget.controller.setLooping(true);
          widget.controller.play();
          log.i('预览视频播放了');
          setState(() {});
        }
      }
    }, onError: (e) {});
  }

  @override
  Widget build(BuildContext context) {
    if (isManualDisposed &&
        widget.controller != null &&
        widget.controller.stype == CustomVideoControllerType.none) {
      isManualDisposed = false;
      log.i('control被刷新了，但是没有初始化');
      widget.controller.initialize().then((_) {
        if (mounted) {
          if (widget.controller != null &&
              widget.controller.stype != CustomVideoControllerType.dispose) {
            widget.controller.setVolume(0);
            widget.controller.setLooping(true);
            widget.controller.play();
            log.i('预览视频播放了');
            setState(() {});
          }
        }
      }, onError: (e) {});
    }
    return (!isManualDisposed &&
            widget.controller != null &&
            widget.controller.stype != CustomVideoControllerType.dispose)
        ? Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: widget.height,
                width: widget.width,
                color: Colors.black,
              ),
              CustomVideoPlayer(
                controller: widget.controller,
                rotateToFullScreen: widget.rotateToFullScreen,
                width: widget.width,
                height: widget.height,
                unInitializedBuilder: widget.unInitializedBuilder,
                progressBar: widget.progressBar,
                gestureWidget: widget.gestureWidget,
                tapCallBack: widget.tapCallBack,
                fullScreenProgressBar: widget.fullScreenProgressBar,
                fullScreenTopUi: widget.fullScreenTopUi,
                isFixWidth: widget.isFixWidth,
              )
            ],
          )
        : widget.disposedWidget ?? Container();
  }
}
