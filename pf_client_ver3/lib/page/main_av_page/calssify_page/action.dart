import 'package:app/pojo/av_data.dart';
import 'package:app/pojo/video_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum CalssifyAction {
  videos,
  clearVideos,
  classify,
  loading,
  refresh,
  filter,
  toggleTitle,
  changeTag
}

class CalssifyActionCreator {
  static Action changeTag(data) {
    return Action(CalssifyAction.changeTag, payload: data);
  }

  static Action clearVideos() {
    return Action(CalssifyAction.clearVideos);
  }

  static Action toggleTitle(var data) {
    return Action(CalssifyAction.toggleTitle, payload: data);
  }

  static Action onClassify(ClassifiesBean classify) {
    return Action(CalssifyAction.classify, payload: classify);
  }

  static Action onVideos(List<VideoBean> videos) {
    return Action(CalssifyAction.videos, payload: videos);
  }

  static Action onLoading() {
    return const Action(CalssifyAction.loading);
  }

  static Action onRefresh() {
    return const Action(CalssifyAction.refresh);
  }

  static Action onFilter() {
    return const Action(CalssifyAction.filter);
  }
}
