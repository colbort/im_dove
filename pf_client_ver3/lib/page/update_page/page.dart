import 'dart:async';
import 'dart:io';
import 'dart:ui';
// import 'package:app/page/update_page/page%20copy.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/event/index.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/version.dart';
import 'package:app/widget/common/toast.dart';
// import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:app/net/net.dart';
// import 'package:app/utils/native.dart';
// import 'package:dio/dio.dart';
import 'package:app/utils/screen.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

int nowTime = 0;

class _CounterWidgetState extends State<CounterWidget> {
  var _lastDownloadPer = .0;
  double _counter;
  bool isUpdating = false;
  bool _iosJumping = false;
  bool downloadError = false;
  _updateClick() async {
    // only ios
    if (Platform.isIOS) {
      if (_iosJumping) return;
      _iosJumping = true;
      setState(() {});
      Timer((Duration(seconds: 10)), () {
        setState(() {
          _iosJumping = false;
        });
      });
      var url = version.downloadLink;
      if (await canLaunch(url) != null) {
        await launch(url);
      } else {
        log.w('Could not launch $url');
      }
      return;
    }

    // only anroid
    if (version.isDownloaded) {
      version.installApk();
      return;
    }

    setState(() {
      downloadError = false;
      isUpdating = true;
      _counter = 0.0;
    });
    _lastDownloadPer = 0;
    var ok = await version.update(
      version.downloadLink,
      onProgress: (received, total) {
        print('$received, $total');
        _counter = received / total;
        if (_counter - _lastDownloadPer >= 0.001) {
          _lastDownloadPer = _counter;
          setState(() => isUpdating = true);
        }
      },
    );
    if (ok) {
      version.installApk();
      setState(() => isUpdating = false);
    } else {
      setState(() {
        downloadError = true;
        isUpdating = false;
      });
      showToast(Lang.DOWNLOAD_ERR, type: ToastType.negative);
    }
  }

  @override
  void initState() {
    super.initState();
    //初始化状态
    _counter = 0.0;
    log.i("initState");
  }

  @override
  Widget build(BuildContext context) {
    return isUpdating && Platform.isAndroid
        ? Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Align(
                alignment: Alignment(0, -0.8),
                child: Text(
                  Lang.UPDATA_DOWNLOADING,
                  style: TextStyle(color: Color(0xFFFFE03C), fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: SizedBox(
                  width: 240,
                  height: 4,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.red[400]),
                    value: _counter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.7 + _counter * 1.4, 0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image(
                      width: 40,
                      height: 20,
                      image: AssetImage(ImgCfg.NOTICE_TIME_STACK),
                    ),
                    Text(
                      ((_counter * 100).toInt()).toString() + '%',
                      style: TextStyle(color: Color(0xFFFFE03C), fontSize: 10),
                    )
                  ],
                ),
              ),
            ],
          )
        : FlatButton(
            color: _iosJumping ? Colors.grey : Color(0xFFFFE03C),
            padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 80.0),
            highlightColor: Colors.yellow[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text(
              version.isDownloaded // isDownloaded
                  ? Lang.UPDATA_ANZHUANG
                  : downloadError ? Lang.UPDATA_CHONGXIN : Lang.UPDATA_UPDATA,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xff363636),
                  fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              // Navigator.of(context).pop();
              _updateClick();
            },
          );
  }
}

showUpdatePage(BuildContext context) {
  if (version.needUpdate) {
    vibrate();
    return showDialog(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NoticePage(
              text: version.info,
              size: version.size,
              versionRemote: version.versionRemote);
        });
  }
}

class NoticePage extends Dialog {
  final String text;
  final String size;
  final String versionRemote;
  NoticePage(
      {Key key,
      @required this.text,
      @required this.size,
      @required this.versionRemote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            //保证控件居中效果
            child: Container(
                width: s.realW(320),
                height: s.realH(380 + 60 + 68),
                padding: const EdgeInsets.only(top: 90),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: s.realW(320),
                      height: s.realH(360),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: -s.realH(110),
                            child: Image(
                              width: s.realW(320),
                              // height: 385,
                              image: AssetImage(ImgCfg.NOTICE_UPDATE_BG),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            top: s.realH(65),
                            child: Text(
                              Lang.UPDATA_TITLE,
                              style: TextStyle(
                                  fontSize: 19.0,
                                  color: Color(0xff363636),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            top: s.realH(93),
                            child: Text(
                              'v$versionRemote',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xff363636),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Positioned(
                            top: s.realH(95),
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: s.realW(250),
                              child: Text(
                                Lang.UPDATA_SIZE + size,
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ),
                          ),
                          Positioned(
                              top: s.realH(120),
                              child: Container(
                                width: s.realW(250),
                                height: s.realH(120),
                                child: Scrollbar(
                                  // 显示进度条
                                  child: SingleChildScrollView(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xff666666)),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 300),
                            child: CounterWidget(),
                          ),
                          // Positioned(
                          //     bottom: s.realH(15),
                          //     child: Container(
                          //         width: 240, child: CounterWidget())),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: version.isForceUpdate
                          ? Container()
                          : GestureDetector(
                              child: Image(
                                width: s.realW(37),
                                height: s.realH(72),
                                image: AssetImage(ImgCfg.NOTICE_UPDATE_CLOSE),
                              ),
                              onTap: () {
                                version.cancelUpdate();
                                Navigator.of(context).pop();
                                isResumed = false;
                              }, //点击
                            ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
