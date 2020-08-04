import 'package:app/pojo/id_video_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum PurchaseAction { refresh, loadmore, refreshOkay, loadMoreOkay }

class PurchaseActionCreator {
  static Action onRefresh() {
    return const Action(PurchaseAction.refresh);
  }

  static Action onLoadMore() {
    return const Action(PurchaseAction.loadmore);
  }

  /// UI 获取数据成功
  static Action onRefreshOkay(List<IdVideoItemBean> datas) {
    return Action(PurchaseAction.refreshOkay, payload: datas);
  }

  static Action onLoadMoreOkay(List<IdVideoItemBean> datas) {
    return Action(PurchaseAction.loadMoreOkay, payload: datas);
  }
}
