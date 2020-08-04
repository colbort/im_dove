import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SelectedState> buildReducer() {
  return asReducer(
    <Object, Reducer<SelectedState>>{
      SelectedAction.carousel: _onCarousel,
      SelectedAction.groups: _onGroups,
    },
  );
}

SelectedState _onCarousel(SelectedState state, Action action) {
  return state.clone()..carouses = action.payload;
}

SelectedState _onGroups(SelectedState state, Action action) {
  return state.clone()..groups = action.payload;
}
