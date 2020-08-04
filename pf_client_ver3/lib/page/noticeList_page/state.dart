import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeListState implements Cloneable<NoticeListState> {
  List<dynamic> list;

  var refreshController = RefreshController(initialRefresh: false);

  bool isInit;

  @override
  NoticeListState clone() {
    return NoticeListState()
      ..list = list
      ..isInit = isInit
      ..refreshController = refreshController;
  }
}

NoticeListState initState(Map<String, dynamic> args) {
  return NoticeListState()
    ..list = []
    ..isInit = true;
}
