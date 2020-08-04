import 'package:app/pojo/video_bean.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SimpleRecommandState implements Cloneable<SimpleRecommandState> {
  int type;
  int latestPlayIndex;
  int curPage; // 使用page和pageSize从1 开始
  List<VideoBean> datas;
  String domin;
  RefreshController refreshcontroller;

  @override
  SimpleRecommandState clone() {
    return SimpleRecommandState()
      ..refreshcontroller = refreshcontroller
      ..type = type
      ..curPage = curPage
      ..datas = datas
      ..domin = domin
      ..latestPlayIndex = latestPlayIndex;
  }
}

SimpleRecommandState initState(int type) {
  return SimpleRecommandState()
    ..refreshcontroller = RefreshController()
    ..type = type
    ..curPage = 1
    ..datas = []
    ..domin = null
    ..latestPlayIndex = 0;
}
