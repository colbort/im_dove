import 'package:app/page/main_pao_page/widget/main_pao_item_component/action.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:fish_redux/fish_redux.dart';

Reducer<MainPaoListState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainPaoListState>>{
      MainPaoItemAction.delPost: _delPost,
    },
  );
}

MainPaoListState _delPost(MainPaoListState state, Action action) {
  final MainPaoListState newState = state.clone();
  int no = action.payload;
  newState.dataList
      .removeWhere((MainPaoItemState state) => state.paoDataModel.no == no);
  return newState;
}
