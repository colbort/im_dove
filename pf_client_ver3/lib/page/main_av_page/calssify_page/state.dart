import 'package:app/page/main_av_page/widgets/custom_sliver.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CalssifyState implements Cloneable<CalssifyState> {
  /// 记录选中的分类
  List<ClassifyBean> selected = List();

  /// 所有视频数据
  VideosBean videos;
  ScrollController scrollController = ScrollController();
  final ScrollController controller = ScrollController();

  /// 所有分类数据
  ClassifiesBean classify;

  /// 当前分页请求index
  int current = 1;

  /// 最后一次请求 index
  int lastPage = 0;

  /// 刷新选中项数据
  DataController dataController = DataController();
  final RefreshController refreshController = RefreshController();

  /// videopreview宽高
  final double itemW = (Dimens.pt360 - 40) / 2;
  final double itemH = (Dimens.pt360 - 40) / 3;

  var showTitle = 56;

  @override
  CalssifyState clone() {
    return CalssifyState()
      ..selected = selected
      ..videos = videos
      ..showTitle = showTitle
      ..scrollController = scrollController
      ..classify = classify
      ..current = current;
  }
}

CalssifyState initState(Map<String, dynamic> args) {
  var scrollController = args['controller'] as ScrollController;
  return CalssifyState()
    ..scrollController = scrollController
    ..videos = VideosBean(videos: List())
    ..selected = [ClassifyBean(), ClassifyBean(), ClassifyBean()];
}
