import 'dart:convert';

import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/main_page/action.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/version.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:sprintf/sprintf.dart';
import 'action.dart';
import 'state.dart';

const _AV_SELECTED_CAROUSEL = '_AV_SELECTED_CAROUSEL';
const _AV_SELECTED_GROUPS = '_AV_SELECTED_GROUPS';
const _AV_SELECTED_CAROUSEL_TIME =
    '_selected_carousel_latest_time_at_version_%s';
const _AV_SELECTED_GROUPS_TIME = '_selected_groups_latest_time_at_version_%s';

Effect<SelectedState> buildEffect() {
  return combineEffects(<Object, Effect<SelectedState>>{
    Lifecycle.initState: _onInit,
    SelectedAction.launchUrl: _onLaunchUrl,
    SelectedAction.next: _onNext,
  });
}

Future<void> _onInit(Action action, Context<SelectedState> ctx) async {
  _getSelectedCarousel(ctx);
  _getSelectedGroup(ctx);
}

Future<void> _getSelectedCarousel(Context<SelectedState> ctx) async {
  var dataStr = await ls.get(_AV_SELECTED_CAROUSEL);
  var lastTime = await _getLatestRequestTime(_AV_SELECTED_CAROUSEL_TIME);
  Carouses bean;
  if (TextUtil.isEmpty(dataStr) ||
      (DateTime.now().difference(lastTime).abs() >= Duration(hours: 24))) {
    bean = await _getSelectedRemoteCarousel();
    _setSelectdCarousel(bean);
    _setLatestRequestTime(_AV_SELECTED_CAROUSEL_TIME);
  } else {
    bean = Carouses.fromJson(json.decode(dataStr));
  }
  ctx.dispatch(SelectedActionCreator.onCarousel(bean));
}

Future<bool> _setSelectdCarousel(Carouses data) async {
  if (data == null || (data?.carouses?.length ?? 0) <= 0) {
    return false;
  }
  var dataStr = json.encode(data.toJson());
  return await ls.save(_AV_SELECTED_CAROUSEL, dataStr);
}

Future<Carouses> _getSelectedRemoteCarousel() async {
  var bean = Carouses();

  var resp = await net.request(
    Routers.CAROUSE_LIST_POST,
    method: 'post',
    args: {
      "type": 3,
    },
  );
  if (resp?.code == 200 && TextUtil.isNotEmpty(resp?.data?.toString())) {
    bean = Carouses.fromJson(resp?.data);
  }

  return bean;
}

Future<void> _getSelectedGroup(Context<SelectedState> ctx) async {
  var dataStr = await ls.get(_AV_SELECTED_GROUPS);
  var lastTime = await _getLatestRequestTime(_AV_SELECTED_GROUPS_TIME);
  VideoGroupsBean bean;
  if (TextUtil.isEmpty(dataStr) ||
      (DateTime.now().difference(lastTime).abs() >= Duration(hours: 24))) {
    bean = await _getSelectedRemoteGroup();
    // _setSelectedGroup(bean);
    _setLatestRequestTime(_AV_SELECTED_GROUPS_TIME);
  } else {
    bean = VideoGroupsBean.fromJson(json.decode(dataStr));
  }
  ctx.dispatch(SelectedActionCreator.onGroups(bean));
}

// Future<bool> _setSelectedGroup(VideoGroupsBean data) async {
//   if (data == null) {
//     return false;
//   }
//   var dataStr = json.encode(data);
//   return await ls.save(_AV_SELECTED_GROUPS, dataStr);
// }

Future<VideoGroupsBean> _getSelectedRemoteGroup() async {
  VideoGroupsBean bean;

  var resp = await net.request(
    Routers.POST_AV_SELECTED_GROUP_VIDEO,
    method: 'post',
  );

  if (resp?.code == 200 && TextUtil.isNotEmpty(resp?.data?.toString())) {
    bean = VideoGroupsBean.fromJson(resp?.data);
  }

  return bean;
}

void _onLaunchUrl(Action action, Context<SelectedState> ctx) async {
  var data = action.payload as CarouseBean;
  switch (data?.linkType) {
    case 1:
      ctx.broadcast(MainActionCreator.onSwitchToTopicAction(data?.jumpApp));
      break;
    case 2:
      Navigator.of(ctx.context).pushNamed('WebviewPage',
          arguments: {'url': data?.jumpH5 ?? "", 'pageName': Lang.GUANGGAO});
      break;
    case 3:
      Navigator.of(ctx.context).pushNamed('WalletPage');
      break;
    case 4:
      Navigator.of(ctx.context).pushNamed('Promotionpage');
      break;
    case 5:
      Navigator.of(ctx.context)
          .pushNamed('WebviewPage', arguments: {'url': data?.jumpH5 ?? ""});
      break;
    case 6:
      Navigator.of(ctx.context).pushNamed('vipNewPage');
      break;
    case 7:
      var url = await _reqChatSignNet();
      Navigator.of(ctx.context).pushNamed('WebviewPage',
          arguments: {'url': url ?? "", 'pageName': Lang.KEFU});
      break;
    default:
  }
}

Future<String> _reqChatSignNet() async {
  var resp = await net.request(Routers.CHAT_SIGN_POST);
  if (resp.code != 200) return null;
  var url = resp.data['url'];
  return url;
}

void _onNext(Action action, Context<SelectedState> ctx) async {
  var temp = action.payload as VideoGroupBean;
  var controller = ctx.state.controllers[temp.topicId];
  VideoGroupBean bean;

  var resp = await net.request(
    Routers.POST_AV_SELECTED_ONE_VIDEO,
    args: {"topicId": temp.topicId},
  );
  if (resp?.code == 200 && TextUtil.isNotEmpty(resp?.data?.toString())) {
    bean = VideoGroupBean.fromJson(resp?.data['topicVideos']);
  }
  if (controller != null && controller?.next != null) {
    controller.next(bean);
    int index = -1;
    for (var group in ctx.state.groups.group) {
      index++;
      if (group.topicId == bean.topicId) {
        break;
      }
    }
    ctx.state.groups.group.removeAt(index);
    ctx.state.groups.group.insert(index, bean);
    // _setSelectedGroup(ctx.state.groups);
    _setLatestRequestTime(_AV_SELECTED_GROUPS_TIME);
  }
}

Future<DateTime> _getLatestRequestTime(String format) async {
  var key = sprintf(format, [version.versionLocal]);
  String lastMillSecondsStr = await ls.get(key);

  if (TextUtil.isNotEmpty(lastMillSecondsStr)) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(lastMillSecondsStr));
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

Future<bool> _setLatestRequestTime(String format) {
  var key = sprintf(format, [version.versionLocal]);
  var cur = DateTime.now().millisecondsSinceEpoch;
  return ls.save(key, cur.toString());
}
