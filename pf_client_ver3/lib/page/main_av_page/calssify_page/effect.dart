import 'dart:convert';

import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/storage/index.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/version.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:sprintf/sprintf.dart';
import 'action.dart';
import 'state.dart';

const _AV_CLASSIFY_MENU = 'AV_CLASSIFY_MENU';
const _AV_CLASSIFY_VIDEOS = 'AV_CLASSIFY_VIDEOS';
const _AV_CLASSIFY_LAST_TIME = '_gold_coin_latest_time_at_version_%s';
const _AV_CLASSIFY_LAST_PAGE = '_gold_coin_latest_page_at_version_%s';

bool net2 = false;

Effect<CalssifyState> buildEffect() {
  return combineEffects(<Object, Effect<CalssifyState>>{
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
    CalssifyAction.loading: _onLoading,
    CalssifyAction.refresh: _onRefresh,
    CalssifyAction.filter: _onFilter,
  });
}

void _init(Action action, Context<CalssifyState> ctx) async {
  _getClassifyHome(ctx);
}

void _dispose(Action action, Context<CalssifyState> ctx) {
  _setLatestRequestPage(ctx.state.current);
}

void _onFilter(Action action, Context<CalssifyState> ctx) {
  ctx.dispatch(CalssifyActionCreator.clearVideos());
  _getRemoteVideos(PAGE_SIZE, 0, ctx);
}

void _onLoading(Action action, Context<CalssifyState> ctx) async {
  _getRemoteVideos(
    PAGE_SIZE,
    ctx.state.videos.videos.length,
    ctx,
  );
}

void _onRefresh(Action action, Context<CalssifyState> ctx) {
  _getRemoteVideos(PAGE_SIZE, 0, ctx);
}

/// 进入页面首次获取分类和视频数据
Future<void> _getClassifyHome(Context<CalssifyState> ctx) async {
  var resp = await net.request(
    Routers.GET_AV_CLASSIFY_HOME,
  );

  print(resp.toString());

  if (resp?.code == 200 && resp?.data != null && resp?.data != '') {
    ClassifiesBean classify = ClassifiesBean.fromJson(resp?.data);
    ctx.dispatch(CalssifyActionCreator.changeTag(
        {'index': 0, 'data': classify?.sorts[0]}));
    ctx.dispatch(CalssifyActionCreator.changeTag(
        {'index': 1, 'data': classify?.categorys[0]}));
    ctx.dispatch(CalssifyActionCreator.changeTag(
        {'index': 2, 'data': classify?.tags[0]}));
    VideosBean videos = VideosBean.fromJson(resp?.data);
    ctx.dispatch(CalssifyActionCreator.onClassify(classify));
    ctx.dispatch(CalssifyActionCreator.onVideos(videos.videos));
    _setClassify(classify);
    _setVideos(videos);
  } else {
    await showConfirm(ctx.context, title: Lang.WANGLUOCUOWU);
  }
}

Future _getRemoteVideos(
  int current,
  int skip,
  Context<CalssifyState> ctx,
) async {
  var resp = await net.request(
    Routers.POST_AV_CLASSIFY_VIDEO,
    method: 'post',
    args: {
      "sortId": ctx.state.selected[0].id,
      "categoryId": ctx.state.selected[1].id,
      "tagId": ctx.state.selected[2].id,
      "skip": skip,
      "limit": current,
    },
  );

  ctx.state.refreshController.loadComplete();
  ctx.state.refreshController.refreshCompleted();

  if (resp?.code == 200) {
    VideosBean bean = VideosBean.fromJson(resp?.data);
    if (bean.videos.length < PAGE_SIZE) {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(CalssifyActionCreator.onVideos(bean.videos));
    _setVideos(bean);
    _setLatestRequestTime();
  }
}

Future<bool> _setClassify(ClassifiesBean data) async {
  if (data == null) {
    return false;
  }
  var dataStr = json.encode(data);
  return await ls.save(_AV_CLASSIFY_MENU, dataStr);
}

Future<bool> _setVideos(VideosBean data) async {
  if (data == null) {
    return false;
  }
  var dataStr = json.encode(data);
  return await ls.save(_AV_CLASSIFY_VIDEOS, dataStr);
}

// Future<DateTime> _getLatestRequestTime() async {
//   var key = sprintf(_AV_CLASSIFY_LAST_TIME, [version.versionLocal]);
//   String lastMillSecondsStr = await ls.get(key);

//   if (TextUtil.isNotEmpty(lastMillSecondsStr)) {
//     return DateTime.fromMillisecondsSinceEpoch(int.parse(lastMillSecondsStr));
//   }
//   return DateTime.fromMillisecondsSinceEpoch(0);
// }

Future<bool> _setLatestRequestTime() {
  var key = sprintf(_AV_CLASSIFY_LAST_TIME, [version.versionLocal]);
  var cur = DateTime.now().millisecondsSinceEpoch;
  return ls.save(key, cur.toString());
}

// Future<int> _getLatestRequestPage() async {
//   var key = sprintf(_AV_CLASSIFY_LAST_PAGE, [version.versionLocal]);
//   String page = await ls.get(key);

//   if (TextUtil.isNotEmpty(page)) {
//     return int.parse(page);
//   }
//   return 1;
// }

Future<bool> _setLatestRequestPage(int page) {
  var key = sprintf(_AV_CLASSIFY_LAST_PAGE, [version.versionLocal]);
  return ls.save(key, page.toString());
}
