import 'dart:async';

import 'package:app/player/video_player/custom_video_control.dart';
import 'package:flutter/material.dart';
import 'time_helper.dart';
import 'ui_helper.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/svg.dart';

///进度条，当前播放时间，最大时间
///CustomVideoController 生命周期不归它控制,该进度条只负责使用
class PFVideoProgressBar extends StatefulWidget {
  final CustomVideoController controller;
  final Function fullScreenDel;
  final String fullScreenIcon;
  final String playBtn;
  final String pauseBtn;
  final bool showLittleCircle;
  const PFVideoProgressBar({
    Key key,
    @required this.controller,
    @required this.playBtn,
    @required this.pauseBtn,
    this.fullScreenDel,
    this.fullScreenIcon,
    this.showLittleCircle = true,
  }) : super(key: key);

  @override
  _PFVideoProgressBarState createState() => _PFVideoProgressBarState();
}

class _PFVideoProgressBarState extends State<PFVideoProgressBar> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Timer progressTimer;
  void startTimer() {
    progressTimer?.cancel();
    progressTimer = Timer.periodic(Duration(milliseconds: 350), (timer) {
      if (widget.controller != null) {
        setState(() {});
      }
    });
  }

  void stopTimer() {
    progressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return buildProgress();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Widget buildProgress() {
    if (widget.controller == null ||
        widget.controller.value == null ||
        !widget.controller.value.initialized) {
      return Container();
    }

    VideoPlayerValue info = widget.controller.value;

    double max = 0.01;
    double current = 0.0;
    double bufferedPosition = 0.0;
    if (info.duration != null) max = info.duration.inSeconds.toDouble();
    if (info.position != null) current = info.position.inSeconds.toDouble();
    if (info.buffered.length > 0)
      bufferedPosition = info.buffered.last.end.inSeconds.toDouble();

    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black54, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Container(
          //   color: Colors.yellow,
          //   width: 100,
          //   height: 20,
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildPlayButton(widget.controller),
              Expanded(
                child: Container(
                  // color: Colors.red,
                  height: 36,
                  child: PFVideoProgressLine(
                    current: current,
                    max: max,
                    buffered: bufferedPosition,
                    isBuffering: true,
                    backgroundColor: Colors.grey,
                    bufferColor: Colors.white,
                    playedColor: Color(0xffffd33c),
                    showLittleCircle: widget.showLittleCircle,
                    changeProgressHandler: (progress) async {
                      double targetSec = progress * max;
                      Duration duration = Duration(seconds: targetSec.toInt());
                      widget.controller.seekTo(duration).then((_) {
                        widget.controller.play();
                      });
                      // tooltipDelegate?.hideTooltip();
                    },
                  ),
                ),
              ),
              widget.fullScreenIcon == null
                  ? Container()
                  : buildFullScreenBtn(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              createText(current),
              createText(max),
            ],
          ),
        ],
      ),
    );
  }

  Widget createText(double inSeconds) {
    return Container(
      child: Text(TimeHelper.getTimeText(inSeconds),
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildFullScreenBtn() {
    return Container(
      // color: Colors.yellow,
      width: 32,
      height: 32,
      child: IconButton(
        alignment: Alignment.bottomCenter,
        iconSize: 24.0,
        padding: EdgeInsets.all(0),
        color: Colors.white,
        icon: SvgPicture.asset(
          widget.fullScreenIcon,
        ),
        onPressed: () {
          print("fullScreenDel");
          if (widget.fullScreenDel != null) {
            widget.fullScreenDel();
          }
        },
      ),
    );
  }

  Widget buildPlayButton(CustomVideoController controller) {
    if (controller == null || controller.value == null) {
      return Container();
    }
    VideoPlayerValue info = controller.value;
    String iconData = widget.playBtn;
    if (info.isPlaying != null) {
      iconData = info.isPlaying ? widget.pauseBtn : widget.playBtn;
    }

    return Container(
      width: 32,
      height: 32,
      child: IconButton(
        alignment: Alignment.bottomCenter,
        iconSize: 24.0,
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        icon: SvgPicture.asset(
          iconData,
          color: Colors.white,
        ),
        onPressed: () {
          if (info.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
      ),
    );
  }
}

class PFVideoProgressLine extends StatefulWidget {
  final double max;
  final double current;
  final double buffered;
  final Color backgroundColor;
  final Color bufferColor;
  final Color playedColor;
  final void Function(double progress) changeProgressHandler;
  // final double progressFlex;

  final bool isBuffering;
  final bool showLittleCircle;

  const PFVideoProgressLine({
    Key key,
    @required this.max,
    @required this.current,
    this.buffered,
    this.backgroundColor = const Color(0xFF616161),
    this.bufferColor = Colors.grey,
    this.playedColor = Colors.white,
    this.isBuffering = false,
    this.changeProgressHandler,
    this.showLittleCircle = true,
    // this.progressFlex = 0.6,
  }) : super(key: key);

  @override
  _PFVideoProgressLineState createState() => _PFVideoProgressLineState();
}

class _PFVideoProgressLineState extends State<PFVideoProgressLine> {
  GlobalKey _progressKey = GlobalKey();

  double tempLeft;

  double get left {
    var l = widget.current / widget.max;
    if (tempLeft != null && widget.isBuffering) {
      return tempLeft;
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.max == null || widget.current == null || widget.max == 0)
      return _buildEmpty();

    var mid = (widget.buffered ?? 0) / widget.max - left;
    if (mid < 0) {
      mid = 0;
    }

    var right = 1 - left - mid;

    Widget progress = buildProgress(left, mid, right,
        showLittleCircle: widget.showLittleCircle);

    if (widget.changeProgressHandler != null) {
      progress = Listener(
        onPointerMove: _pointerMove,
        child: GestureDetector(
          child: Container(color: Colors.transparent, child: progress),
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onTapUp: _onTapUp,
        ),
      );
    }
    return progress;
  }

  _buildEmpty() {
    return Container();
  }

  // int get flex => (widget.progressFlex * 100).toInt();

  Widget buildProgress(double left, double mid, double right,
      {bool showLittleCircle = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Flexible(child: Container(), flex: 8),
        Flexible(
          flex: 10,
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.centerStart,
            // alignment: const FractionalOffset(widget.buffered ?? 0, 0.5),
            // alignment: Alignment(widget.buffered, 0.5),
            children: <Widget>[
              Row(
                key: _progressKey,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildColorWidget(widget.playedColor, left),
                  buildColorWidget(widget.bufferColor, mid),
                  buildColorWidget(widget.backgroundColor, right),
                ],
              ),
              //MARK:操作按钮
              showLittleCircle
                  ? Align(
                      alignment: Alignment(left * 2 - 1, 0),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffffd33c),
                        ),
                      ),
                    )
                  : Container(),
              //MARK:文字提示
              isDrag
                  ? Align(
                      alignment: Alignment(left * 2 - 1, -30),
                      child: Text(
                        '${TimeHelper.getTimeText(left * widget.max)}',
                        style: TextStyle(
                          color: Colors.black,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        Flexible(child: Container(), flex: 4),
      ],
    );
  }

  Widget buildColorWidget(Color color, double flex) {
    if (flex == double.nan ||
        flex == double.infinity ||
        flex == double.negativeInfinity) {
      flex = 0;
    }
    if (flex == 0) {
      return Container();
    }
    return Flexible(
      flex: (flex * 1000).toInt(),
      child: Container(
        height: 2,
        color: color,
      ),
    );
  }

  bool isDrag = false;

  void _onTapUp(TapUpDetails details) {
    isDrag = false;
    var progress = getProgress(details.globalPosition);
    if (progress == null) {
      return;
    }
    setState(() {
      tempLeft = progress;
    });
    widget.changeProgressHandler(progress);
  }

  void _pointerMove(PointerMoveEvent e) {
    if (!isDrag) isDrag = true;
    var progress = getProgress(e.position);
    if (progress == null) {
      return;
    }
    setState(() {
      tempLeft = progress;
    });
  }

  getProgress(Offset globalPosition) {
    var offset = _getLocalOffset(globalPosition);
    if (offset == null) return null;
    var globalRect = UIHelper.findGlobalRect(_progressKey);
    var progress = offset.dx / globalRect.width;
    if (progress > 1)
      progress = 1;
    else if (progress < 0) progress = 0;
    return progress;
  }

  Offset _getLocalOffset(Offset globalPosition) {
    return UIHelper.globalOffsetToLocal(
      _progressKey,
      globalPosition,
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    isDrag = false;
    if (tempLeft != null) {
      widget.changeProgressHandler(tempLeft);
      // tempLeft = null;
    }
  }
}
