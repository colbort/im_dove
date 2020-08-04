import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/net/net.dart';
import './noticeItem_component/state.dart';

Effect<NoticeListState> buildEffect() {
  return combineEffects(<Object, Effect<NoticeListState>>{
    Lifecycle.initState: _init,
    NoticeListAction.getNoticeList: _fetchList
  });
}

void _init(Action action, Context<NoticeListState> ctx) async {
  const data = {
    'page': 1,
    'pageSize': 20,
  };
  ctx.dispatch(NoticeListActionCreator.getNoticeList(data));
}

void _fetchList(Action action, Context<NoticeListState> ctx) async {
  var data = await _reqAllHistory(action.payload['params']);
  ctx.state.refreshController.refreshCompleted();
  ctx.state.refreshController.loadComplete();
  if (data != null) {
    var d = data["data"].map((f) {
      return NoticeItemState(
          name: f['name'], createdAt: f['createdAt'], content: f['content']);
    }).toList();
    ctx.dispatch(NoticeListActionCreator.saveNoticeList(d));
  } else {
    ctx.dispatch(NoticeListActionCreator.saveNoticeList([]));
  }
}

Future _reqAllHistory(args) async {
  final resp = await net.request(Routers.ANN_FINDALLHISTORY_GET, args: args);

  return resp.code == 200 ? resp.data : null;
}
