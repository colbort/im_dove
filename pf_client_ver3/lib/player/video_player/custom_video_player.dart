import 'dart:async';
import 'dart:io';

import 'package:app/player/video_element/uninitialized_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:video_player/video_player.dart';
import 'package:home_indicator/home_indicator.dart';
import 'custom_video_control.dart';

typedef TapCallBack = Function(dynamic);

typedef UnInitializedWidgetBuilder = Widget Function(
    double width, double height, TapCallBack tapCallBack);

typedef ProgressBuilder = Function(CustomVideoController);

typedef GestureBuilder = Function(CustomVideoController, TapCallBack);

///播放器组件
class CustomVideoPlayer extends StatefulWidget {
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

  const CustomVideoPlayer({
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
  }) : super(key: key);
  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  var isUpMode = true;
  @override
  void initState() {
    isUpMode = true;
    widget.controller.freshCallback = (ctrl) {
      if (mounted) setState(() {});
    };
    HomeIndicator.show();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.freshCallback = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    var nowUpMode = false;
    if (_width > _height) {
      nowUpMode = false;
    } else {
      nowUpMode = true;
    }

    //如果是竖屏或者不需要检测旋转全屏,则完全按照屏幕设置的宽高，来设置播放器的大小
    if (nowUpMode || !widget.rotateToFullScreen) {
      widget.controller.isFullScreen = false;
      isUpMode = true;
      if (widget.controller.stype == CustomVideoControllerType.dispose ||
          !widget.controller.value.initialized) {
        return widget.unInitializedBuilder(
            widget.width, widget.height, widget.tapCallBack);
      }

      var videoWidth = widget.width;
      var videoHeight = widget.width / widget.controller.value.aspectRatio;
      if (!widget.isFixWidth) {
        if (videoHeight > widget.height) {
          videoHeight = widget.height;
          videoWidth = videoHeight * widget.controller.value.aspectRatio;
        }
      } else {
        if (videoHeight > widget.height * 1.8) {
          videoHeight = widget.height * 1.8;
          videoWidth = videoHeight * widget.controller.value.aspectRatio;
        }
      }

      return Container(
        color: Colors.black,
        width: widget.width > videoWidth ? widget.width : videoWidth,
        height: widget.height > videoHeight ? widget.height : videoHeight,
        child: Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: videoWidth,
              height: videoHeight,
              child: VideoPlayer(widget.controller),
            ),
            widget.gestureWidget != null
                ? widget.gestureWidget(widget.controller, widget.tapCallBack)
                : Container(),
            widget.progressBar != null
                ? Align(
                    alignment: Alignment(0, 1),
                    child:
                        Container(child: widget.progressBar(widget.controller)),
                  )
                : Container(),
            widget.controller.isBuffing
                ? Align(
                    alignment: Alignment(0, 0),
                    child: buildLoading(),
                  )
                : Container(),
          ],
        ),
      );
    }
    //现在是横屏
    else {
      widget.controller.isFullScreen = true;
      if (isUpMode) {
        isUpMode = false;
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            _showFullScreenWithRotateBox(
                context,
                widget.controller,
                widget.unInitializedBuilder,
                widget.fullScreenProgressBar,
                widget.fullScreenTopUi,
                widget.gestureWidget));
      }

      return Container();
    }
  }
}

CustomVideoController _fullScreenCtrl;
_showFullScreenWithRotateBox(
    BuildContext context,
    CustomVideoController controller,
    UnInitializedWidgetBuilder unInitializedBuilder,
    ProgressBuilder fullScreenProgressBar,
    Widget fullScreenTopUi,
    GestureBuilder gestureWidget) {
  if (controller == null || controller.value == null) return;
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  _fullScreenCtrl = controller;
  Navigator.push(
    context,
    PFDialogRoute(
      builder: (ctx) {
        // int quarterTurns;

        // if (axis == Axis.horizontal) {
        //   if (mediaQueryData.orientation == Orientation.landscape) {
        //     quarterTurns = 0;
        //   } else {
        //     quarterTurns = 1;
        //   }
        // } else {
        //   quarterTurns = 0;
        // }

        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;

        return FullWidget(height, width, unInitializedBuilder,
            fullScreenProgressBar, fullScreenTopUi, gestureWidget);
      },
    ),
  );
}

class FullWidget extends StatefulWidget {
  FullWidget(this.height, this.width, this.unInitializedBuilder,
      this.fullScreenProgressBar, this.fullScreenTopUi, this.gestureWidget);

  final double height;
  final double width;
  final UnInitializedWidgetBuilder unInitializedBuilder;
  final ProgressBuilder fullScreenProgressBar;
  final Widget fullScreenTopUi;
  final GestureBuilder gestureWidget;

  @override
  State<StatefulWidget> createState() {
    return _FullPageState();
  }
}

class _FullPageState extends State<FullWidget> with TickerProviderStateMixin {
  var showUi = false;
  var isExited = false;
  @override
  void initState() {
    isExited = false;
    showUi = false;
    _fullScreenCtrl.freshCallback = (ctrl) {
      if (mounted)
        setState(() {
          _fullScreenCtrl = ctrl;
        });
    };
    HomeIndicator.hide();
    super.initState();
  }

  @override
  void dispose() {
    _fullScreenCtrl.freshCallback = null;
    super.dispose();
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
  }

  Timer aotuHideTimer;
  void tapCallBack(_showUi) {
    aotuHideTimer?.cancel();
    aotuHideTimer = null;
    setState(() {
      if (_showUi == null) {
        showUi = !showUi;
        if (showUi) {
          SystemChrome.setEnabledSystemUIOverlays(
              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          aotuHideTimer = Timer(Duration(seconds: 7), () {
            if (mounted) {
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
              setState(() {
                showUi = false;
              });
            }
          });
        } else {
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        }
      } else {
        showUi = _showUi;
        if (showUi) {
          SystemChrome.setEnabledSystemUIOverlays(
              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          aotuHideTimer = Timer(Duration(seconds: 7), () {
            if (mounted) {
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
              setState(() {
                showUi = false;
              });
            }
          });
        } else {
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    var nowUpMode = false;
    if (width > height) {
      nowUpMode = false;
    } else {
      nowUpMode = true;
    }

    //现在是竖屏
    if (nowUpMode) {
      if (!isExited) {
        isExited = true;
        SystemChrome.setEnabledSystemUIOverlays(
            [SystemUiOverlay.bottom, SystemUiOverlay.top]);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      }

      return Container();
    }

    if (_fullScreenCtrl.stype == CustomVideoControllerType.dispose ||
        !_fullScreenCtrl.value.initialized) {
      return widget.unInitializedBuilder(width, height, tapCallBack);
    }

    //ios 全屏顶部栏显示一个黑条，先屏蔽
    if (Platform.operatingSystem != "ios") {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.black12);
    }

    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        width: widget.height,
        height: widget.width, //MediaQuery.of(context).size.height,
        padding: EdgeInsets.zero,
        child: WillPopScope(
          onWillPop: () async {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            return false;
          },
          child: Center(
            child: AspectRatio(
              aspectRatio: _fullScreenCtrl.value.aspectRatio,
              child: Container(
                padding: EdgeInsets.all(0),
                color: Colors.black,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_fullScreenCtrl),
                    widget.gestureWidget != null
                        ? widget.gestureWidget(_fullScreenCtrl, tapCallBack)
                        : Container(),
                    widget.fullScreenProgressBar != null && showUi
                        ? widget.fullScreenProgressBar(_fullScreenCtrl)
                        : Container(),
                    _fullScreenCtrl.isBuffing
                        ? Align(
                            alignment: Alignment(0, 0),
                            child: buildLoading(),
                          )
                        : Container(),
                    (showUi && widget.fullScreenTopUi != null)
                        ? widget.fullScreenTopUi
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PFDialogRoute<T> extends PageRoute<T> {
  final Color barrierColor;
  final String barrierLabel;
  final bool maintainState;
  final Duration transitionDuration;
  final WidgetBuilder builder;

  PFDialogRoute({
    this.barrierColor = const Color(0x44FFFFFF),
    this.barrierLabel = "full",
    this.maintainState = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    @required this.builder,
  }) : assert(barrierColor != Colors.transparent,
            "The barrierColor must not be transparent.");

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
