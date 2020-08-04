import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

class MainPaoCommentListState implements Cloneable<MainPaoCommentListState> {
  List<PaoCommentModel> dataList = [];

  bool inited = false;

  @override
  MainPaoCommentListState clone() {
    return MainPaoCommentListState()
      ..dataList = dataList
      ..inited = inited;
  }
}

MainPaoCommentListState initState(Map<String, dynamic> args) {
  return MainPaoCommentListState();
}
