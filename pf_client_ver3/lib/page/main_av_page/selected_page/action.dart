import 'package:app/pojo/av_data.dart';
import 'package:fish_redux/fish_redux.dart';

enum SelectedAction { carousel, groups, launchUrl, next }

class SelectedActionCreator {
  static Action onCarousel(Carouses carousel) {
    return Action(SelectedAction.carousel, payload: carousel);
  }

  static Action onGroups(VideoGroupsBean groups) {
    return Action(SelectedAction.groups, payload: groups);
  }

  static Action onLaunchUrl(CarouseBean data) {
    return Action(SelectedAction.launchUrl, payload: data);
  }

  static Action onNext(VideoGroupBean data) {
    return Action(SelectedAction.next, payload: data);
  }
}
