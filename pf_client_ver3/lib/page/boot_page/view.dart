import 'dart:async';

import 'package:app/page/boot_page/start_animation/anmiation_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter_svg/svg.dart';

import 'action.dart';
import 'state.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildView(BootState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.loose,
      children: <Widget>[
        (state.getAdImg && !state.showingAni)
            ? GestureDetector(
                child: CachedNetworkImage(
                    imageUrl: state.adImgUrl,
                    cacheManager: ImgCacheMgr(),
                    width: MediaQuery.of(viewService.context).size.width,
                    //height: MediaQuery.of(viewService.context).size.height,
                    fit: BoxFit.fitWidth),
                onTap: () async {
                  var url = state.jumpUrl;
                  if (!url.contains('http') && !url.contains('https')) {
                    url = 'http://' + url;
                  }
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              )
            : ScaleAnimationRoute(),
        SafeArea(
          child: Align(
            alignment: Alignment(1.0, -1.0),
            child: Stack(
              children: <Widget>[
                (state.getAdImg && !state.showingAni)
                    ? Positioned(
                        top: s.realW(28),
                        right: s.realH(17),
                        child: SvgPicture.asset(
                          'assets/boot/count_bg.svg',
                          color: Colors.grey[700],
                          width: s.realW(40),
                          height: s.realH(40),
                          alignment: Alignment.center,
                        ),
                      )
                    : Container(),
                (state.getAdImg && !state.showingAni)
                    ? (state.countDown
                        ? Positioned(
                            top: s.realW(28),
                            right: s.realW(17),
                            child: SvgPicture.asset(
                              'assets/player/close.svg',
                              width: s.realW(40),
                              height: s.realH(40),
                              color: Colors.white,
                              alignment: Alignment.center,
                            ),
                          )
                        : Positioned(
                            top: s.realW(28),
                            right: s.realW(17),
                            child: Container(
                              alignment: Alignment.center,
                              width: s.realW(40),
                              height: s.realH(40),
                              child: CountDownWidget(
                                seconds: state.countSeconds,
                                onCountDownFinishCallBack: (bool value) {
                                  if (value) {
                                    //print('count down');
                                    dispatch(
                                        BootActionCreator.onCountDownAction(
                                            true));
                                  }
                                },
                              ),
                            ),
                          ))
                    : Container(),
                Positioned(
                  top: s.realW(28),
                  right: s.realW(17),
                  child: GestureDetector(
                    child: Container(
                      width: s.realW(45),
                      height: s.realH(45),
                      color: Color(0X00FFFFFF),
                    ),
                    onTap: () {
                      if (state.countDown) {
                        dispatch(BootActionCreator.onEnterAction());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          child: Container(
            child: state.version.isNotEmpty
                ? Text(
                    'v${state.version}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      shadows: [BoxShadow(color: Colors.white, blurRadius: 2)],
                    ),
                    textAlign: TextAlign.left,
                  )
                : Container(),
          ),
        )
      ],
    ),
  );
}

class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;
  final seconds;

  CountDownWidget(
      {Key key,
      @required this.onCountDownFinishCallBack,
      @required this.seconds})
      : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  int _seconds;

  @override
  void initState() {
    _seconds = widget.seconds;
    super.initState();
    _cancelTimer();
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(fontSize: 22, color: Colors.white),
    );
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
