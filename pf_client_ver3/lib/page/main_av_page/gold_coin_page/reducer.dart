import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<GoldCoinState> buildReducer() {
  return asReducer(
    <Object, Reducer<GoldCoinState>>{
      GoldCoinAction.update: _onUpdate,
    },
  );
}

GoldCoinState _onUpdate(GoldCoinState state, Action action) {
  return state.clone()..videos = action.payload;
}
