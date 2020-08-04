import 'package:app/lang/lang.dart';
import 'package:app/page/webview_page/view.dart';
import 'package:app/widget/common/toast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BasePage extends StatelessWidget {
  BasePage({Key key}) : super(key: key);
  String screenName();
}

mixin BasicPage on BasePage {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    var backColor =
        screenName() == Lang.KAICHEQUN ? Color((0xFFf2f2f2)) : Colors.white;
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     dismissAllToast();
        //     return true;
        //   },
        //   child:
        Container(
      color: backColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              actions: actions(),
              title: Text(
                screenName(),
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: backColor,
              leading: leading(context)),
          body: Container(
            child: body(),
            color: backColor,
          ),
          floatingActionButton: fab(),
        ),
      ),
    );
    // );
  }

  Widget body();
  Widget fab() => Container();
  Widget leading(context) => IconButton(
      icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
      onPressed: () {
        dismissAllToast();
        flutterWebviewPlugin.show();
        Navigator.of(context).pop();
      });
  List<Widget> actions() => <Widget>[];
}
