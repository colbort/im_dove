import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ExchangeState> buildReducer() {
  return asReducer(
    <Object, Reducer<ExchangeState>>{
      ExchangeAction.action: _onAction,
    },
  );
}

ExchangeState _onAction(ExchangeState state, Action action) {
  final ExchangeState newState = state.clone();
  return newState;
}
