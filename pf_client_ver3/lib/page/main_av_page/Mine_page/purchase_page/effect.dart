import 'dart:convert';

import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/pojo/bought_bean.dart';
import 'package:app/storage/index.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/version.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<PurchaseState> buildEffect() {
  return combineEffects(<Object, Effect<PurchaseState>>{
    Lifecycle.initState: _onInit,
    PurchaseAction.refresh: _onRefresh,
    PurchaseAction.loadmore: _onLoadMore,
  });
}

void _onInit(Action action, Context<PurchaseState> ctx) async {
  // 加载缓存数据
  var bean = await _getLatestData();
  ctx.state.domin = bean?.domain;
  ctx.dispatch(PurchaseActionCreator.onRefreshOkay(bean?.data));
  // 检查是否自动刷新
  var lastTime = await _getLatestRequestTime();
  if (DateTime.now().difference(lastTime).abs() >= Duration(hours: 24)) {
    ctx.state.refreshcontroller.requestRefresh();
    ctx.dispatch(PurchaseActionCreator.onRefreshOkay(null));
    ctx.dispatch(PurchaseActionCreator.onRefresh());
  }
}

void _onRefresh(Action action, Context<PurchaseState> ctx) {
  _getData(ctx, 0);
}

void _onLoadMore(Action action, Context<PurchaseState> ctx) {
  int page = ctx.state.curPage;
  _getData(ctx, page);
}

/// 业务，获取数据并处理
_getData(Context<PurchaseState> ctx, int curPage) async {
  // var bean = await _genData(type, page);
  var bean = await _getDataReqNet2(ctx.context, curPage);
  // var bean = await _getDataReqNet1(ctx, type, page);
  if (null == bean) {
    if (curPage == 0) {
      ctx.state.refreshcontroller.refreshFailed();
    } else {
      ctx.state.refreshcontroller.loadFailed();
    }
    ctx.dispatch(PurchaseActionCreator.onRefreshOkay(null));
    return;
  } else {
    _setLatestData(bean);
    _setLatestRequestTime();
    ctx.state.domin = bean.domain;
    if (curPage == 0) {
      // dorefresh okay
      ctx.state.refreshcontroller.refreshCompleted();
      ctx.state.curPage = 0;
      if ((bean.data?.length ?? 0) < PAGE_SIZE) {
        ctx.state.refreshcontroller.loadNoData();
      }
      ctx.dispatch(PurchaseActionCreator.onRefreshOkay(bean.data));
    } else {
      // doLoadMore okay
      ctx.state.refreshcontroller.loadComplete();
      if ((bean.data?.length ?? 0) > 0) {
        ctx.state.curPage = curPage + 1;
      }
      if ((bean.data?.length ?? 0) < PAGE_SIZE) {
        ctx.state.refreshcontroller.loadNoData();
      }
      ctx.dispatch(PurchaseActionCreator.onLoadMoreOkay(bean.data));
    }
  }
}

Future<BoughtBean> _getDataReqNet2(BuildContext context, int curPage) async {
  BoughtBean bean;
  try {
    bean = await netManager.client.getBoughtVideos(curPage * PAGE_SIZE);
  } catch (e) {
    l.e('resp:', e);
  }
  if (null == bean) {
    await showConfirm(context, child: Text(Lang.WANGLUOCUOWU));
    return null;
  }
  return bean;
}

/// 保存最近一页的请求数据
Future<bool> _setLatestData(BoughtBean data) async {
  if (null == data) return false;
  var key = '_latest_bought_key';
  var map = data.toJson();
  var dataStr = json.encode(map);
  // return lightModel.setString(key, dataStr);
  return ls.save(key, dataStr);
}

/// 获取��近一页的请求数据
Future<BoughtBean> _getLatestData() async {
  var key = '_latest_bought_key';
  // var dataStr = await lightModel.getString(key);
  var dataStr = await ls.get(key);
  if (TextUtil.isEmpty(dataStr)) return null;
  try {
    var map = json.decode(dataStr);
    if (null == map) return null;
    return BoughtBean.fromJson(map);
  } catch (e) {
    l.e("error", e);
    ls.remove(key);
  }
  return null;
}

/// 获取最后一个获取数据的时间
Future<DateTime> _getLatestRequestTime() async {
  var key = '_bought_latest_time_at_version_${version.versionLocal}';
  // String lastMillSecondsStr = await lightModel.getString(key);
  String lastMillSecondsStr = await ls.get(key);

  if (TextUtil.isNotEmpty(lastMillSecondsStr)) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(lastMillSecondsStr));
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

/// ���置最后一次获取时间的
Future<bool> _setLatestRequestTime() {
  var key = '_bought_latest_time_at_version_${version.versionLocal}';
  var cur = DateTime.now().millisecondsSinceEpoch;
  return ls.save(key, cur.toString());
  // return lightModel.setString(key, cur.toString());
}
