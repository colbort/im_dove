import 'dart:io';

import 'package:app/lang/lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///加载弹框
class ProgressDialog {
  static bool _isShowing = false;

  static void show(BuildContext context, Function setProgressCallBack) {
    showProgress(
      context,
      // child: Container(
      //   width: 1000,
      //   height: 2000,
      //   color: Color.fromRGBO(147, 147, 147, 0.5),
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ///loading框
            new SpinKitPouringHourglass(color: Color.fromRGBO(245, 230, 63, 1)),
            SizedBox(
              height: 10,
            ),

            ///上传中文本
            TipsWidget(setProgressCallBack: setProgressCallBack)
          ]),
    );
  }

  ///展示
  static void showProgress(BuildContext context,
      {Widget child = const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.yellow),
      )}) {
    if (!_isShowing) {
      _isShowing = true;
      Navigator.push(
        context,
        _PopRoute(
          child: _Progress(
            child: child,
          ),
        ),
      );
    }
  }

  ///隐藏
  static void dismiss(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

class TipsWidget extends StatefulWidget {
  final setProgressCallBack;

  TipsWidget({Key key, @required this.setProgressCallBack}) : super(key: key);

  @override
  _TipsWidgetState createState() => _TipsWidgetState();
}

class _TipsWidgetState extends State<TipsWidget> {
  int progress;
  String tips;

  void updateProgress(String tips, int progress) {
    this.tips = tips;
    this.progress = progress;
    setState(() {});
  }

  @override
  void initState() {
    tips = Platform.isAndroid
        ? Lang.UPLOAD_COMPRESS_PROGRESS
        : Lang.UPLOAD_UPLOAD_PROGRESS;
    progress = 0;
    if (widget.setProgressCallBack != null)
      widget.setProgressCallBack(this.updateProgress);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.setProgressCallBack != null) widget.setProgressCallBack(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      Lang.val(tips, args: [progress]),
      style: TextStyle(
        color: Color.fromRGBO(245, 230, 63, 1),
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  _Progress({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
