import 'package:app/page/recommend_page/action.dart';
import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<RecommendPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<RecommendPageState>>{
      RecommandPageAction.refreshUI: _onRefreshUI,
    },
  );
}

RecommendPageState _onRefreshUI(RecommendPageState state, Action action) {
  return state.clone();
}
