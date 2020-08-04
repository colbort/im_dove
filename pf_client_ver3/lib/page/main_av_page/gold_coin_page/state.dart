import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GoldCoinState implements Cloneable<GoldCoinState> {
  VideosBean videos;
  int current = 1;
  final double itemW = Dimens.pt360 - 30;
  final double itemH = (Dimens.pt360 - 30) * 2 / 3;
  final RefreshController controller = RefreshController();
  int lastPage = 1;
  @override
  GoldCoinState clone() {
    return GoldCoinState()
      ..videos = videos
      ..current = current;
  }
}

GoldCoinState initState(Map<String, dynamic> args) {
  return GoldCoinState();
}
