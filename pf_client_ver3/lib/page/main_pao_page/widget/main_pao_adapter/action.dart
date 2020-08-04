import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainPaoAction {
  /// 添加数据
  loadMore,
}

class MainPaoActionCreator {
  // static Action onAction() {
  //   return const Action(MainPaoAction.action);
  // }

  static Action loadMore(List<PaoDataModel> data) {
    return Action(MainPaoAction.loadMore, payload: data);
  }
}
