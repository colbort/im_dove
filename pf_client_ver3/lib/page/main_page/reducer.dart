import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainState>>{
      MainAction.switchIndex: _onSwitchIndexAction,
      // MainAction.showFloatingButton: _onShowFloatingButtonAction,
      MainAction.onShowUpdater: _onShowUpdater,
      MainAction.setVideoState: _onSetVideoAction,
      // MainAction.showFullFloatingActionButton: _showFullFloatingActionButton
    },
  );
}

MainState _onSwitchIndexAction(MainState state, Action action) {
  final MainState newState = state.clone();
  newState.index = action.payload;
  return newState;
}

// MainState _onShowFloatingButtonAction(MainState state, Action action) {
//   final MainState newState = state.clone();
//   newState.showFloatingActionButton = action.payload;
//   return newState;
// }

MainState _onShowUpdater(MainState state, Action action) {
  final MainState newState = state.clone();
  newState.showUpdater = action.payload;
  return newState;
}

MainState _onSetVideoAction(MainState state, Action action) {
  final MainState newState = state.clone();
  newState.isAlowedBackApp = action.payload;
  return newState;
}

// MainState _showFullFloatingActionButton(MainState state, Action action) {
//   final MainState newState = state.clone();
//   newState.isShowFullFloatingActionButton = action.payload;
//   return newState;
// }
