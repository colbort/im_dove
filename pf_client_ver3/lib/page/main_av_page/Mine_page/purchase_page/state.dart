import 'package:app/pojo/id_video_item_bean.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PurchaseState implements Cloneable<PurchaseState> {
  int curPage; // 使用skip分页从0开始
  List<IdVideoItemBean> datas;
  String domin;
  RefreshController refreshcontroller;

  final double itemW = (Dimens.pt360 - 40) / 2;
  final double itemH = (Dimens.pt360 - 40) / 3;

  @override
  PurchaseState clone() {
    return PurchaseState()
      ..curPage = curPage
      ..datas = datas
      ..domin = domin
      ..refreshcontroller = refreshcontroller;
  }
}

PurchaseState initState(Map<String, dynamic> args) {
  return PurchaseState()
    ..curPage = 0
    ..datas = <IdVideoItemBean>[]
    ..domin = ''
    ..refreshcontroller = RefreshController();
}
