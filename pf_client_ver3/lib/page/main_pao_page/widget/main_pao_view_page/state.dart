import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPaoViewState implements Cloneable<MainPaoViewState> {
  List<MainPaoItemState> dataList = [];
  List<PaoBloggerModel> bloggerItemList = [];
  int stype = 1;
  RefreshController refreshController = RefreshController();
  @override
  MainPaoViewState clone() {
    return MainPaoViewState()
      ..stype = stype
      ..dataList = dataList
      ..refreshController = refreshController
      ..bloggerItemList = bloggerItemList;
  }
}

MainPaoViewState initState(Map<String, dynamic> args) {
  var d = MainPaoViewState()..stype = args == null ? 1 : args["stype"];
  return d;
}

class MainPaoViewConnector extends ConnOp<MainPaoViewState, MainPaoListState>
    with ReselectMixin<MainPaoViewState, MainPaoListState> {
  @override
  MainPaoListState computed(MainPaoViewState state) {
    return MainPaoListState()..dataList = state.dataList;
  }

  @override
  List<dynamic> factors(MainPaoViewState state) {
    return <dynamic>[...state.dataList];
  }

  @override
  void set(MainPaoViewState state, MainPaoListState subState) {
    state.dataList = subState.dataList;
  }
}
