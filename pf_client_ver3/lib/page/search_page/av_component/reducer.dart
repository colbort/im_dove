import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<AvState> buildReducer() {
  return asReducer(
    <Object, Reducer<AvState>>{
      // AvAction.action: _onAction,
    },
  );
}
