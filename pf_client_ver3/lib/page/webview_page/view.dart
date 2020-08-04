import 'dart:convert';
import 'dart:io';

import 'package:app/cfg.dart';
import 'package:app/utils/logger.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'state.dart';

// Future _reqAllTopic() async {
//   var resp = await net.request(Routers.VIDEO_ALLTOPIC_POST);
//   return resp.code == 200 ? resp.data : null;
// }

Widget buildView(
    WebviewState state, Dispatch dispatch, ViewService viewService) {
  return _WebviewPage(
      state: state, dispatch: dispatch, viewService: viewService);
}

final flutterWebviewPlugin = new FlutterWebviewPlugin();

final wc = WebViewChannel._();

// class ChannelModel

/// protocol list
/// [Jump]
List<String> _protocols = ['Jump'];

String christmasId = cfg.isDev ? '15741' : '11812';

class WebViewChannel {
  WebViewChannel._();
  _jumpControl(params, ViewService viewService) async {
    if (params['page'] == 'pre') {
      Navigator.of(viewService.context).pop();
    } else {
      Navigator.of(viewService.context).pushNamed(params['page']);
    }
  }

  JavascriptChannel callFlutter(ViewService viewService) {
    return JavascriptChannel(
        name: 'CallFlutter',
        onMessageReceived: (JavascriptMessage message) {
          flutterWebviewPlugin.hide();
          var _msg = jsonDecode(message.message);
          Map<String, Function> _mapFn = {'Jump': _jumpControl};

          if (!_protocols.contains(_msg['name'])) {
            log.e('${_msg['name']} Protocol is not support!');
            return;
          }

          if (_mapFn[_msg['name']] != null) {
            _mapFn[_msg['name']](_msg['params'], viewService);
          }
        });
  }
}

class _WebviewPage extends StatelessWidget {
  final WebviewState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _WebviewPage({Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return state.isWebView
        ? Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: WebviewScaffold(
                resizeToAvoidBottomInset: Platform.isAndroid ? true : false,
                appBar: state.pageName != null
                    ? AppBar(
                        elevation: 0,
                        title: Text(
                          state.pageName,
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.white,
                        leading: leading(context))
                    : null,
                url: state.url,
                withJavascript: true,
                clearCache: true,
                useWideViewPort: true,
                javascriptChannels: <JavascriptChannel>[
                  wc.callFlutter(viewService),
                ].toSet(),
              ),
            ),
          )
        : Container();
  }

  Widget leading(context) => IconButton(
      icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
      onPressed: () {
        Navigator.of(context).pop();
      });
}
