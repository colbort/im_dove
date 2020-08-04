import 'dart:convert';

import 'package:app/net2/net_manager.dart';
import 'package:app/pojo/recommend_bean.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/preview_manager.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/version.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import '../../../lang/lang.dart';
import '../../../widget/common/confirm.dart';
import 'action.dart';
import 'state.dart';

Effect<SimpleRecommandState> buildEffect() {
  return combineEffects(<Object, Effect<SimpleRecommandState>>{
    Lifecycle.initState: _onInit,
    SimpleRecommandAction.refresh: _onRefresh,
    SimpleRecommandAction.loadmore: _onLoadMore,
  });
}

void _onInit(Action action, Context<SimpleRecommandState> ctx) async {
  // 加载缓存数据
  var bean = await _getLatestData(ctx.state.type);
  ctx.state.domin = bean?.domain;
  ctx.dispatch(SimpleRecommandActionCreator.onRefreshOkay(bean?.videos));
  // 检查是否自动刷新
  var lastTime = await _getLatestRequestTime(ctx.state.type);
  if (DateTime.now().difference(lastTime).abs() >= Duration(hours: 24)) {
    ctx.state.refreshcontroller.requestRefresh();
    ctx.dispatch(SimpleRecommandActionCreator.onRefreshOkay(null));
    ctx.dispatch(SimpleRecommandActionCreator.onRefresh());
  }
  previewModule.addListener(() {
    if (previewModule.recommendPageIndex == 0 &&
        ctx.state.type == RECOMMAND_TYPE_GUANFANG) {
      if (previewModule.enable) {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item');
        ctx.dispatch(SimpleRecommandActionCreator.onAutoPlayUI(
            previewModule.lastPlayIndex));
      } else {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item 但是被禁止了');
      }
    } else if (previewModule.recommendPageIndex == 1 &&
        ctx.state.type == RECOMMAND_TYPE_PAOYOU) {
      if (previewModule.enable) {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item');
        ctx.dispatch(SimpleRecommandActionCreator.onAutoPlayUI(
            previewModule.lastPlayIndex));
      } else {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item 但是被禁止了');
      }
    } else if (previewModule.recommendPageIndex == 2 &&
        ctx.state.type == RECOMMAND_TYPE_BANGDAN) {
      if (previewModule.enable) {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item');
        ctx.dispatch(SimpleRecommandActionCreator.onAutoPlayUI(
            previewModule.lastPlayIndex));
      } else {
        l.d('autoPlay',
            '恢复播放在第${previewModule.recommendPageIndex}页的第${previewModule.lastPlayIndex}个item 但是被禁止了');
      }
    }
  });
}

void _onRefresh(Action action, Context<SimpleRecommandState> ctx) {
  _getData(ctx, ctx.state.type, 1);
}

void _onLoadMore(Action action, Context<SimpleRecommandState> ctx) {
  int page = ctx.state.curPage + 1;
  _getData(ctx, ctx.state.type, page);
}

/// 业务，获取数据并处理
_getData(Context<SimpleRecommandState> ctx, int type, int page) async {
  // var bean = await _genData(type, page);
  var bean = await _getDataReqNet2(ctx, type, page);
  // var bean = await _getDataReqNet1(ctx, type, page);
  if (null == bean) {
    if (page == 1) {
      ctx.state.refreshcontroller.refreshFailed();
    } else {
      ctx.state.refreshcontroller.loadFailed();
    }
    ctx.dispatch(SimpleRecommandActionCreator.onRefreshOkay(null));
    return;
  } else {
    _setLatestData(ctx.state.type, bean);
    _setLatestRequestTime(ctx.state.type);
    ctx.state.domin = bean.domain;
    if (page == 1) {
      // dorefresh okay
      ctx.state.refreshcontroller.refreshCompleted();
      ctx.state.curPage = 1;
      if ((bean.videos?.length ?? 0) < PAGE_SIZE) {
        ctx.state.refreshcontroller.loadNoData();
      }
      ctx.dispatch(SimpleRecommandActionCreator.onRefreshOkay(bean.videos));
    } else {
      // doLoadMore okay
      ctx.state.refreshcontroller.loadComplete();
      ctx.state.curPage = page;
      if ((bean.videos?.length ?? 0) < PAGE_SIZE) {
        ctx.state.refreshcontroller.loadNoData();
      }
      ctx.dispatch(SimpleRecommandActionCreator.onLoadMoreOkay(bean.videos));
    }
  }
}

// /// 获取推荐数据
// Future<RecommendBean> _getDataReqNet1(
//     Context<SimpleRecommandState> ctx, int type, int page) async {
//   var resp = await net.request(Routers.THEMATIC_AV_VIDEO_LIST_POST,
//       args: {"id": type, "page": page, "pageSize": PAGE_SIZE});
//   if (resp == null || resp.code != 200) {
//     await showConfirm(ctx.context, child: Text(Lang.WANGLUOCUOWU));
//     return null;
//   } else {
//     Map map;
//     if (resp.data is Map) {
//       map = resp.data;
//     } else if (resp.data is String) {
//       if (TextUtil.isNotEmpty(resp.data)) map = json.decode(resp.data);
//     }

//     if (null == map) return null;
//     return RecommendBean.fromJson(map);
//   }
// }

/// 获取推荐数据net2
Future<RecommendBean> _getDataReqNet2(
    Context<SimpleRecommandState> ctx, int type, int page) async {
  RecommendBean bean;
  try {
    bean = await netManager.client.getRecommendData(type, page);
  } catch (e) {
    l.e('resp:', e);
  }
  if (null == bean) {
    await showConfirm(ctx.context, child: Text(Lang.WANGLUOCUOWU));
    return null;
  }
  return bean;
}

/// 制造一些假数据
// Future<RecommendBean> _genData(int type, int page) async {
//   await Future.delayed(Duration(seconds: 2));
//   if (page >= 3) {
//     return null;
//   }
//   var videos = List.generate(PAGE_SIZE, (index) {
//     var rib = VideoBean()
//       ..id = Random().nextInt(10000)
//       ..title = '禁断的介护${Random().nextInt(10)}'
//       ..playTime = 100
//       ..width = 360
//       ..height = 240
//       // ..recTags = [VideoTag(id: 0, name: '巨乳'), VideoTag(id: 1, name: '大白腿')]
//       ..actors = [
//         IdNameTag(id: 0, name: '泷泽萝拉${Random().nextInt(20)}'),
//         IdNameTag(id: 1, name: '天海翼${Random().nextInt(20)}')
//       ]
//       ..attributes = VideoAttributes(
//           needPay: index % 2 == 0,
//           isVip: index % 2 == 1,
//           price: Random().nextDouble().toStringAsFixed(2))
//       ..preUrl =
//           'http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4'
//       ..coverImg = [
//         'https://tp.xkodm.com/d/file/bigpic/2019-07-11/19/1942161128.jpg'
//       ]
//       ..type = 1
//       ..createdAt = DateTime.now().toIso8601String()
//       ..totalWatchTimes = 10000
//       ..totalRecomTimes = 9528
//       ..star = Random().nextInt(11)
//       ..attributes = VideoAttributes(
//           isVip: index % 2 == 1,
//           needPay: index % 2 == 0,
//           price: Random().nextDouble().toStringAsFixed(2));

//     // if (type == RECOMMAND_TYPE_BANGDANG) {
//     //   rib.bangdanIndex = index + 1;
//     // }
//     return rib;
//   });

//   return RecommendBean(domain: "www.baidu.com", videos: videos);
// }

/// 保存最近一页的请求数据
Future<bool> _setLatestData(int type, RecommendBean data) async {
  if (null == data) return false;
  var key = '_recommend_key_in_type_$type';
  var map = data.toJson();
  var dataStr = json.encode(map);
  // return lightModel.setString(key, dataStr);
  return ls.save(key, dataStr);
}

/// 获取��近一页的请求数据
Future<RecommendBean> _getLatestData(int type) async {
  var key = '_recommend_key_in_type_$type';
  // var dataStr = await lightModel.getString(key);
  var dataStr = await ls.get(key);
  if (TextUtil.isEmpty(dataStr)) return null;
  try {
    var map = json.decode(dataStr);
    if (null == map) return null;
    return RecommendBean.fromJson(map);
  } catch (e) {
    l.e("error", e);
    ls.remove(key);
  }
  return null;
}

/// 获取最后一个获取数据的时间
Future<DateTime> _getLatestRequestTime(int type) async {
  var key =
      '_recommend_latest_time_in_type_${type}_at_version_${version.versionLocal}';
  // String lastMillSecondsStr = await lightModel.getString(key);
  String lastMillSecondsStr = await ls.get(key);

  if (TextUtil.isNotEmpty(lastMillSecondsStr)) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(lastMillSecondsStr));
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

/// ���置最后一次获取时间的
Future<bool> _setLatestRequestTime(int type) {
  var key =
      '_recommend_latest_time_in_type_${type}_at_version_${version.versionLocal}';
  var cur = DateTime.now().millisecondsSinceEpoch;
  return ls.save(key, cur.toString());
  // return lightModel.setString(key, cur.toString());
}
