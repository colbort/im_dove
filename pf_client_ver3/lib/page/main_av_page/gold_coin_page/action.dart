import 'package:app/pojo/av_data.dart';
import 'package:fish_redux/fish_redux.dart';

enum GoldCoinAction { update, loading, refresh }

class GoldCoinActionCreator {
  static Action onUpdate(VideosBean videos) {
    return Action(GoldCoinAction.update, payload: videos);
  }

  static Action onLoading() {
    return const Action(GoldCoinAction.loading);
  }

  static Action onRefresh() {
    return const Action(GoldCoinAction.refresh);
  }
}
