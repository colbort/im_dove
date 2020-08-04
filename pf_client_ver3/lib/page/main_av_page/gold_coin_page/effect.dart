import 'dart:convert';

import 'package:app/net/net.dart';
import 'package:app/net/routers.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/storage/index.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/version.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:sprintf/sprintf.dart';
import 'action.dart';
import 'state.dart';

const _AV_GOLD_COIN_VIDEOS = '_AV_GOLD_COIN_VIDEOS';
const _AV_GLOD_COIN_LAST_TIME = '_gold_coin_latest_time_at_version_%s';
const _AV_GLOD_COIN_LAST_PAGE = '_gold_coin_latest_page_at_version_%s';

Effect<GoldCoinState> buildEffect() {
  return combineEffects(<Object, Effect<GoldCoinState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _dispose,
    GoldCoinAction.loading: _onLoading,
    GoldCoinAction.refresh: _onRefresh,
  });
}

void _onInit(Action action, Context<GoldCoinState> ctx) async {
  ctx.state.lastPage = await _getLatestRequestPage();
  _getVideos(ctx);
}

void _dispose(Action action, Context<GoldCoinState> ctx) {
  _setLatestRequestPage(ctx.state.current);
}

void _onLoading(Action action, Context<GoldCoinState> ctx) async {
  if (ctx.state.current == ctx.state.lastPage) {
    ctx.state.current++;
  }
  var bean = await _getRemoteVideosNet(ctx.context, ctx.state.current + 1);
  if (bean != null) {
    ctx.state.current++;
  }
  ctx.state.controller.loadComplete();
  if ((bean?.videos?.length ?? 0) < PAGE_SIZE) {
    ctx.state.controller.loadNoData();
  }
  _setVideos(bean);
  _setLatestRequestTime();
  ctx.state.videos?.videos?.addAll(bean.videos);
  ctx.dispatch(GoldCoinActionCreator.onUpdate(ctx.state.videos));
}

void _onRefresh(Action action, Context<GoldCoinState> ctx) async {
  var bean = await _getRemoteVideosNet(ctx.context, ctx.state.current = 1);
  ctx.state.controller.refreshCompleted();
  ctx.state.controller.resetNoData();
  _setVideos(bean);
  _setLatestRequestTime();
  ctx.dispatch(GoldCoinActionCreator.onUpdate(bean));
}

Future<void> _getVideos(Context<GoldCoinState> ctx) async {
  var lastTime = await _getLatestRequestTime();
  var dataStr = await ls.get(_AV_GOLD_COIN_VIDEOS);
  VideosBean bean;
  if ((DateTime.now().difference(lastTime).abs() >= Duration(hours: 24)) ||
      TextUtil.isEmpty(dataStr)) {
    if (ctx.state.current == ctx.state.lastPage) {
      ctx.state.current++;
    }
    bean = await _getRemoteVideosNet(ctx.context, ctx.state.current);
    _setVideos(bean);
    _setLatestRequestTime();
  } else {
    bean = VideosBean.fromJson(json.decode(dataStr));
  }

  ctx.dispatch(GoldCoinActionCreator.onUpdate(bean));
}

Future<bool> _setVideos(VideosBean groups) async {
  if (groups == null) {
    return false;
  }
  var dataStr = json.encode(groups);
  return await ls.save(_AV_GOLD_COIN_VIDEOS, dataStr);
}

Future<VideosBean> _getRemoteVideosNet(BuildContext context, int page) {
  return _getRemoteVideosNet1(page);
  // return _getRemoteVideosNet2(context, page);
}

/// 获取网络数据V1
/// 使用网络模块1
Future<VideosBean> _getRemoteVideosNet1(int current) async {
  var resp = await net.request(
    Routers.POST_AV_GOLD_COIN_VIDEO,
    method: 'post',
    args: {
      "page": current,
      "pageSize": PAGE_SIZE,
    },
  );
  VideosBean bean;
  if (resp?.code == 200 && TextUtil.isNotEmpty(resp?.data?.toString())) {
    bean = VideosBean.fromJson(resp?.data);
  } else {
    //  FIXE 获取数据失败，提示
  }
  return bean;
}

/// 获取网络数据V2
/// 使用网络模块2
// Future<VideosBean> _getRemoteVideosNet2(BuildContext context, int page) async {
//   VideosBean bean;
//   try {
//     bean = await netManager.client.getCoinVideos(page);
//   } catch (e) {
//     l.e('resp:', e);
//   }
//   if (null == bean) {
//     bool ok = await showConfirm(context, child: Text(Lang.WANGLUOCUOWU));
//     return null;
//   }
//   return bean;
// }

Future<DateTime> _getLatestRequestTime() async {
  var key = sprintf(_AV_GLOD_COIN_LAST_TIME, [version.versionLocal]);
  String lastMillSecondsStr = await ls.get(key);

  if (TextUtil.isNotEmpty(lastMillSecondsStr)) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(lastMillSecondsStr));
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

Future<bool> _setLatestRequestTime() {
  var key = sprintf(_AV_GLOD_COIN_LAST_TIME, [version.versionLocal]);
  var cur = DateTime.now().millisecondsSinceEpoch;
  return ls.save(key, cur.toString());
}

Future<int> _getLatestRequestPage() async {
  var key = sprintf(_AV_GLOD_COIN_LAST_PAGE, [version.versionLocal]);
  String page = await ls.get(key);

  if (TextUtil.isNotEmpty(page)) {
    return int.parse(page);
  }
  return 1;
}

Future<bool> _setLatestRequestPage(int page) {
  var key = sprintf(_AV_GLOD_COIN_LAST_PAGE, [version.versionLocal]);
  return ls.save(key, page.toString());
}
