import 'dart:async';

import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoRecordState implements Cloneable<VideoRecordState> {
  ViewRecordsBean records;
  final RefreshController controller = RefreshController();
  StreamSubscription subscription;

  final double itemW = (Dimens.pt360 - 40) / 2;
  final double itemH = (Dimens.pt360 - 40) / 3;

  @override
  VideoRecordState clone() {
    return VideoRecordState()
      ..records = records
      ..subscription = subscription;
  }
}

VideoRecordState initState(Map<String, dynamic> args) {
  return VideoRecordState()..records = ViewRecordsBean();
}
