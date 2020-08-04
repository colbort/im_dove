import 'dart:math';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/config/defs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NvDetailState implements Cloneable<NvDetailState> {
  List actorVideos;
  Map otherData;
  int id;
  RefreshController refreshController;
  bool isInit;
  @override
  NvDetailState clone() {
    return NvDetailState()
      ..id = id
      ..isInit = isInit
      ..otherData = otherData
      ..refreshController = refreshController
      ..actorVideos = actorVideos;
  }

  /// 获取ids
  List getIds() {
    if (actorVideos.length <= 0) return [];
    var ids = actorVideos.map((f) {
      return f['id'];
    }).toList();

    return ids.sublist(max(ids.length - defs.idsMaxLen, 0));
  }

  /// 获取最后的观看次数
  getLastWatchTimes() {
    if (actorVideos.length <= 0) return 0;
    return actorVideos.last['totalWatchTimes'];
  }
}

NvDetailState initState(Map<String, dynamic> args) {
  RefreshController controller = RefreshController();
  return NvDetailState()
    ..id = args["id"] == null ? 0 : int.parse(args["id"])
    ..refreshController = controller
    ..isInit = true
    ..otherData = {
      'domain': '',
      'actorsName': '',
      'actorsPhoto': '',
      'actorIntroduction': '',
    }
    ..actorVideos = [];
}
