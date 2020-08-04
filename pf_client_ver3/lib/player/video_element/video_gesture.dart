import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'progress_helper.dart';
import 'ui_helper.dart';
import 'volume_bright_helper.dart';

///播放器手势容器，这里只包含快进，快退，音量，屏幕亮度显示
class PFVideoGesture extends StatefulWidget {
  final CustomVideoController controller;
  final TapCallBack tapCallback;
  final double width;
  final double height;
  const PFVideoGesture({
    Key key,
    @required this.controller,
    @required this.tapCallback,
    this.width = -1,
    this.height = -1,
  }) : super(key: key);

  @override
  _PFVideoGestureState createState() => _PFVideoGestureState();
}

class _PFVideoGestureState extends State<PFVideoGesture> {
  GlobalKey currentKey = GlobalKey();
  @override
  void initState() {
    isShowingIcons = false;
    super.initState();
  }

  ProgressCalculator _calculator;
  String topText;
  IconData topIconData;
  String bottomText;
  IconData bottomIconData;

  ///是否显示亮度，音量等提示图标
  bool isShowingIcons;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: buildContent(context),
      onDoubleTap: _onDoubleTap,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onTap: _onTap,
      key: currentKey,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    double _width =
        (widget.width < 0) ? MediaQuery.of(context).size.width : widget.width;
    double _height = (widget.height < 0)
        ? _width / widget.controller.value.aspectRatio
        : widget.height;
    return Container(
      // color: Colors.yellow,
      width: _width,
      height: _height,
      child: !isShowingIcons
          ? Container()
          : Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(0),
                        ),
                      ),
                      //显示水平拖拽文字
                      Center(
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //文字显示
                              topIconData == null || topText == null
                                  ? Container()
                                  : Container(
                                      // height: 12,
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            topIconData,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          Text(
                                            topText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              //文字显示
                              bottomText == null || bottomIconData == null
                                  ? Container()
                                  : Container(
                                      // height: 12,
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            bottomIconData,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          Text(
                                            bottomText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _onTap() {
    setState(() {
      isShowingIcons = false;
    });

    if (widget.tapCallback != null && widget.tapCallback is TapCallBack) {
      widget.tapCallback(null);
    }
  }

  void _onDoubleTap() {
    widget.controller.value.isPlaying
        ? widget.controller.pause()
        : widget.controller.play();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    VideoPlayerValue value = widget.controller.value;
    _calculator = ProgressCalculator(details, value);
    setState(() {
      isShowingIcons = true;
    });

    if (widget.tapCallback != null && widget.tapCallback is TapCallBack) {
      widget.tapCallback(false);
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_calculator == null || details == null) {
      return;
    }
    // print("_onHorizontalDragUpdate");
    bottomText = _calculator.calcSeek(details);
    var offsetPosition = _calculator.getOffsetPosition();
    bottomIconData =
        offsetPosition > 0 ? Icons.fast_forward : Icons.fast_rewind;
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) async {
    // print("_onHorizontalDragEnd");
    topText = null;
    topIconData = null;
    bottomText = null;
    bottomIconData = null;

    setState(() {
      isShowingIcons = false;
    });

    var targetSeek = _calculator?.getTargetSeek(details);
    _calculator = null;
    if (targetSeek == null) {
      return;
    }
    VideoPlayerValue value = widget.controller.value;
    if (value == null || value.duration == null) return;
    await widget.controller.seekTo(Duration(seconds: targetSeek.toInt()));
    if (targetSeek < value.duration.inSeconds.toDouble())
      await widget.controller.play();
  }

  bool verticalDragging = false;
  bool leftVerticalDrag;
  void _onVerticalDragStart(DragStartDetails details) {
    // print("_onVerticalDragStart");
    verticalDragging = true;
    var width = UIHelper.findGlobalRect(currentKey).width;
    var dx =
        UIHelper.globalOffsetToLocal(currentKey, details.globalPosition).dx;
    leftVerticalDrag = dx / width <= 0.5;
    setState(() {
      isShowingIcons = true;
    });

    if (widget.tapCallback != null && widget.tapCallback is TapCallBack) {
      widget.tapCallback(false);
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) async {
    // print("_onVerticalDragUpdate");
    if (verticalDragging == false) return;
    volumeBrightInfo(leftVerticalDrag, details, widget.controller).then((data) {
      if (data != null) {
        topText = data[0];
        topIconData = data[1];
        setState(() {});
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // print("_onVerticalDragEnd");
    verticalDragging = false;
    leftVerticalDrag = null;

    topText = null;
    topIconData = null;
    bottomText = null;
    bottomIconData = null;

    setState(() {
      isShowingIcons = false;
    });
  }
}
