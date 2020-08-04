import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPaoListState extends MutableSource
    implements Cloneable<MainPaoListState> {
  List<MainPaoItemState> dataList = [];

  RefreshController refreshController = RefreshController();

  // ScrollController controller = ScrollController();
  bool inited = true;
  @override
  MainPaoListState clone() {
    return MainPaoListState()
      ..refreshController = refreshController
      ..dataList = dataList
      // ..controller = controller
      ..inited = inited;
  }

  @override
  Object getItemData(int index) {
    return dataList[index];
  }

  @override
  String getItemType(int index) {
    return paoPostItem;
  }

  @override
  int get itemCount => dataList == null ? 0 : dataList.length;

  @override
  void setItemData(int index, Object data) {
    dataList[index] = data;
  }
}

MainPaoListState initState(Map<String, dynamic> args) {
  return MainPaoListState();
}
