import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<MainPaoListState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoListState>>{
      // MainPaoListAction.action: _onAction,
    },
  );
}

// MainPaoListState _onAction(MainPaoListState state, Action action) {
//   final MainPaoListState newState = state.clone();
//   return newState;
// }
