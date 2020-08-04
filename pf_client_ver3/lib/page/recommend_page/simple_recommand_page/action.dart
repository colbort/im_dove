import 'package:app/pojo/video_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum SimpleRecommandAction {
  refresh,
  loadmore,
  autoPlayUI,
  refreshOkay,
  loadMoreOkay
}

class SimpleRecommandActionCreator {
  static Action onRefresh() {
    return const Action(
      SimpleRecommandAction.refresh,
    );
  }

  static Action onLoadMore() {
    return const Action(
      SimpleRecommandAction.loadmore,
    );
  }

  /// UI 获取数据成功
  static Action onRefreshOkay(List<VideoBean> datas) {
    return Action(SimpleRecommandAction.refreshOkay, payload: datas);
  }

  static Action onLoadMoreOkay(List<VideoBean> datas) {
    return Action(SimpleRecommandAction.loadMoreOkay, payload: datas);
  }

  static Action onAutoPlayUI(int index) {
    return Action(SimpleRecommandAction.autoPlayUI, payload: index);
  }
}
