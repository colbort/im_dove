import 'dart:async';

import 'package:app/loc_server/download.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:app/utils/utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

///播放器未初始化状态，错误状态显示
Widget buildUnInitializedWidget(
    double width, double height, TapCallBack tapCallBack) {
  return GestureDetector(
    onTap: () {
      if (tapCallBack != null) {
        tapCallBack(null);
      }
    },
    child: Container(
      width: width,
      height: height,
      color: Colors.black,
      child: buildLoading(),
    ),
  );
}

Widget buildLoading() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        height: 16.0,
        child: const FlareActor(
          'assets/player/loading.flr',
          animation: 'Untitled',
        ),
      ),
      SizedBox(height: 5),
      //MARK:显示网速
      NetSpeedWidget(),
    ],
  );
}

class NetSpeedWidget extends StatefulWidget {
  const NetSpeedWidget({Key key});
  @override
  _NetSpeedWidgetState createState() => new _NetSpeedWidgetState();
}

class _NetSpeedWidgetState extends State<NetSpeedWidget> {
  Timer _freshTimer;
  @override
  void initState() {
    super.initState();
    _freshTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Text(
        byteFmt(getNowSpeed()),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _freshTimer?.cancel();
    _freshTimer = null;
  }
}
