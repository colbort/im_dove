import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

final fetchData = {
  "actorId": '',
  "ids": '',
  "lastWatchTimes": '',
  "pageSize": 30,
};

Effect<NvDetailState> buildEffect() {
  return combineEffects(<Object, Effect<NvDetailState>>{
    Lifecycle.initState: _onInit,
    NvDetailAction.getDetial: _getDetial
  });
}

/// 女优详情
Future _onInit(Action action, Context<NvDetailState> ctx) async {
  ctx.dispatch(NvDetailActionCreator.getDetial());
}

Future _getDetial(Action action, Context<NvDetailState> ctx) async {
  fetchData['actorId'] = ctx.state.id;
  fetchData['ids'] = ctx.state.getIds();
  fetchData['lastWatchTimes'] = ctx.state.getLastWatchTimes();
  var data = await onAappActorsDetailNet();
  ctx.state.refreshController.loadComplete();
  if (data['videos'].length < 5) {
    ctx.state.refreshController.loadNoData();
  }
  ctx.dispatch(NvDetailActionCreator.saveActorsDetail(data));
}

Future onAappActorsDetailNet() async {
  var d =
      await net.request(Routers.VIDEO_FINDVIDEOBYACTOR_POST, args: fetchData);
  return d.code == 200 ? d.data : {};
}
