import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FemaleListPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<FemaleListPageState>>{
      FemaleListPageAction.saveFamaleList: _saveFamaleList,
      FemaleListPageAction.changeLetter: _changeLetter,
      FemaleListPageAction.changeLetterList: _changeLetterList,
    },
  );
}

FemaleListPageState _saveFamaleList(FemaleListPageState state, Action action) {
  final FemaleListPageState newState = state.clone();
  newState.famaleListMap = action.payload['list'];
  newState.domain = action.payload['domain'];
  return newState;
}

FemaleListPageState _changeLetter(FemaleListPageState state, Action action) {
  final FemaleListPageState newState = state.clone();
  newState.lettersSelected = action.payload;
  return newState;
}

FemaleListPageState _changeLetterList(
    FemaleListPageState state, Action action) {
  final FemaleListPageState newState = state.clone();
  newState.letters = action.payload;
  return newState;
}
