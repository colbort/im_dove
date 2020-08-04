import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';

import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaoBaState implements Cloneable<PaoBaState> {
  List<MainPaoItemState> dataList = [];
  List<Map<String, dynamic>> userList = [];
  RefreshController refreshUserController;

  @override
  PaoBaState clone() {
    return PaoBaState()
      ..dataList = dataList
      ..userList = userList
      ..refreshUserController = refreshUserController;
  }
}

// PaoBaState initState(Map<String, dynamic> args) {
//   return PaoBaState()..dataList = [];
// }

class MainPaoViewConnector extends ConnOp<PaoBaState, MainPaoListState>
    with ReselectMixin<PaoBaState, MainPaoListState> {
  @override
  MainPaoListState computed(PaoBaState state) {
    return MainPaoListState()..dataList = state.dataList;
  }

  @override
  List<dynamic> factors(PaoBaState state) {
    return <dynamic>[...state.dataList];
  }

  @override
  void set(PaoBaState state, MainPaoListState subState) {
    throw Exception('Unexcepted to set MainPaoViewState from MainPaoListState');
  }
}
