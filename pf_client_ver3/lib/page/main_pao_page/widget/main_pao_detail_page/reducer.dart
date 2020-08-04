import 'package:app/page/comment_page/model/comment_model.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MainPaoDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoDetailState>>{
      // MainPaoDetailAction.action: _onAction,
      MainPaoDetailAction.postRefresh: _postRefresh,
      MainPaoDetailAction.commoentRefresh: _commoentRefresh,
    },
  );
}

// MainPaoDetailState _onAction(MainPaoDetailState state, Action action) {
//   final MainPaoDetailState newState = state.clone();
//   return newState;
// }

MainPaoDetailState _postRefresh(MainPaoDetailState state, Action action) {
  final MainPaoDetailState newState = state.clone();
  PaoDataModel data = action.payload;
  if (data != null) {
    data.bPlaying = false;
    newState.paoDataModel = data;
  }
  return newState;
}

MainPaoDetailState _commoentRefresh(MainPaoDetailState state, Action action) {
  final MainPaoDetailState newState = state.clone();
  List<CommentModel> list = action.payload;
  if (list != null) {
    newState.commentModelList = list;
  }
  return newState;
}
