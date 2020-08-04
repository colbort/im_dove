import 'package:app/lang/lang.dart';
import 'package:fish_redux/fish_redux.dart';

class WebviewState implements Cloneable<WebviewState> {
  String url;
  String pageName = Lang.JIAZAIZHONG;
  bool isWebView = true;
  @override
  WebviewState clone() {
    return WebviewState()
      ..pageName = pageName
      ..isWebView = isWebView;
  }
}

WebviewState initState(Map<String, dynamic> args) {
  return WebviewState()
    ..url = args['url']
    ..pageName = args['pageName'] ?? null;
}
