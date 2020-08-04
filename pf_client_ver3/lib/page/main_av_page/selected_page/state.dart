import 'package:app/page/main_av_page/widgets/video_group.dart';
import 'package:app/pojo/av_data.dart';
import 'package:fish_redux/fish_redux.dart';

class SelectedState implements Cloneable<SelectedState> {
  Carouses carouses;
  VideoGroupsBean groups;
  Map<int, NextController> controllers = Map();

  @override
  SelectedState clone() {
    return SelectedState()
      ..carouses = carouses
      ..groups = groups
      ..controllers = controllers;
  }
}

SelectedState initState(Map<String, dynamic> args) {
  return SelectedState()..groups = VideoGroupsBean(group: List());
}
