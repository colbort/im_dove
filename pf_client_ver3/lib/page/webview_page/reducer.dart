import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WebviewState> buildReducer() {
  return asReducer(
    <Object, Reducer<WebviewState>>{
      WebviewAction.onChangeView: _onChangeView,
    },
  );
}

WebviewState _onChangeView(WebviewState state, Action action) {
  final WebviewState newState = state.clone();
  newState.isWebView = action.payload;
  return newState;
}
