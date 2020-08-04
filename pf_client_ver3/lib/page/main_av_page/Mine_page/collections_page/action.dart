import 'package:app/pojo/id_video_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum CollectionsAction { refresh, loadmore, refreshOkay, loadMoreOkay }

class CollectionsActionCreator {
  static Action onRefresh() {
    return const Action(CollectionsAction.refresh);
  }

  static Action onLoadMore() {
    return const Action(CollectionsAction.loadmore);
  }

  /// UI 获取数据成功
  static Action onRefreshOkay(List<IdVideoItemBean> datas) {
    return Action(CollectionsAction.refreshOkay, payload: datas);
  }

  static Action onLoadMoreOkay(List<IdVideoItemBean> datas) {
    return Action(CollectionsAction.loadMoreOkay, payload: datas);
  }
}
