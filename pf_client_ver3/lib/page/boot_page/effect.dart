import 'dart:io';

import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/page/notice_page/page.dart';
import 'package:app/page/spread_page/page.dart';
import 'package:app/page/update_page/page.dart';
import 'package:app/page/wallet_page/effect.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:app/utils/screen.dart';
import 'package:app/event/index.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'start_animation/anmiation_view.dart';
import 'package:app/utils/version.dart';
import 'package:app/utils/hosts.dart';
import 'package:app/utils/passcode.dart';
import 'package:app/umplus/umplus.dart' as umplus;
import 'dart:math';

Effect<BootState> buildEffect() {
  return combineEffects(<Object, Effect<BootState>>{
    BootAction.enter: _onEnter,
    Lifecycle.initState: _onInitState,
    Lifecycle.dispose: _onDispose,
  });
}

String adImgUrl;
String jumpUrl;

getAppAds(Action action, Context<BootState> ctx) async {
  var data = await net.request(Routers.AD_APPADS_POST, args: {"location": 1});
  if (data.code == 200) {
    if (ctx == null) return;

    //如果没有任何广告数据则直接进应用
    if (data.data == null) {
      ctx.dispatch(BootActionCreator.onEnterAction());
      return;
    }
    String domain = data.data['domain'];
    List<dynamic> adModels = data.data['adModels'];
    //如果没有广告则直接进应用
    if (domain == null ||
        domain.isEmpty ||
        adModels == null ||
        adModels.length == 0) {
      ctx.dispatch(BootActionCreator.onEnterAction());
      return;
    }

    if (domain.isNotEmpty && adModels != null && adModels.length > 0) {
      var adModel;
      if (adModels.length > 1) {
        var rng = new Random();
        var randIdx = rng.nextInt(adModels.length);
        // log.i("randIdx:" + randIdx.toString());
        adModel = adModels[randIdx];
      } else {
        adModel = adModels[0];
      }
      adImgUrl = domain + adModel['img'];
      jumpUrl = adModel['jumpURL'];
      var rlt = await ImgCacheMgr().getSingleFile(adImgUrl);
      if (rlt != null) {
        ctx.dispatch(BootActionCreator.onAdInfo(true, adImgUrl, jumpUrl));
      } else {
        ctx.dispatch(BootActionCreator.onEnterAction());
      }
    }
  } else if (ctx != null) {
    ctx.dispatch(BootActionCreator.onEnterAction());
    return;
  }
}

void _onEnter(Action action, Context<BootState> ctx) {
  // TODO 为什么要reset下Screen？
  s.reset();
  Navigator.of(ctx.context).pushReplacementNamed(page_main);
  var nowTime = DateTime.now().millisecondsSinceEpoch;
  var duration = (nowTime - lastEventTime) ~/ 1000;
  lastEventTime = nowTime;
  umplus
      .event(umplus.Events.enterMain, data: {'duration': duration}).sendEvent();
}

var retryTimes = 0;
Future selectLine(BuildContext ctx) async {
  var sltRlt = await hosts.select();
  if (sltRlt == null || sltRlt.isEmpty) {
    if (retryTimes < 1) {
      log.i('选线失败重试');
      retryTimes++;
      return selectLine(ctx);
    } else {
      bool ok = await showConfirm(ctx, child: Text(Lang.WANGLUOCUOWU));
      if (ok) {
        return selectLine(ctx);
      } else {
        return selectLine(ctx);
      }
    }
  } else {
    retryTimes = 0;
    return sltRlt;
  }
}

Future<bool> _login(BuildContext ctx) async {
  bool rlt = await net.login();
  if (!rlt) {
    if (retryTimes < 1) {
      log.i('登录失败重试');
      retryTimes++;
      return _login(ctx);
    } else {
      bool ok = await showConfirm(ctx, child: Text(Lang.WANGLUOCUOWU));
      if (ok) {
        return _login(ctx);
      } else {
        return _login(ctx);
      }
    }
  } else {
    retryTimes = 0;
    return true;
  }
}

Future<bool> initUpdater(BuildContext ctx) async {
  bool rlt = await version.initUpdater();
  if (!rlt) {
    if (retryTimes < 1) {
      log.i('获取版本信息失败重试');
      retryTimes++;
      return initUpdater(ctx);
    } else {
      bool ok = await showConfirm(ctx, child: Text(Lang.WANGLUOCUOWU));
      if (ok) {
        return initUpdater(ctx);
      } else {
        return initUpdater(ctx);
      }
    }
  } else {
    retryTimes = 0;
    return true;
  }
}

var lastEventTime = 0;
void _onInitState(Action action, Context<BootState> ctx) async {
  log.i("boot page _onInitState");
  if (Platform.operatingSystem == "ios") {
    await umplus.init('5e1c8ab54ca35781c50000ce', 'official');
  } else {
    await umplus.init('5e1c8a6f570df3732c0000f0', 'official');
  }
  lastEventTime = DateTime.now().millisecondsSinceEpoch;
  umplus.event(umplus.Events.startApp).sendEvent();
  freshBootPageEventBus = EventBus();
  freshBootPageEventBus.on().listen((event) async {
    ctx.dispatch(BootActionCreator.onFreshAction());
    if (bootAniBus != null) {
      bootAniBus.fire(null);
    }
    Future.delayed(Duration(milliseconds: 3500), () {
      ctx.dispatch(BootActionCreator.onFreshAniState(false));
    });
  });

  //如果不需要密码锁，4秒后改变动画状态
  var code = await passcode.request();
  if (code == null || code.isEmpty) {
    if (bootAniBus != null) {
      bootAniBus.fire(null);
    }
    Future.delayed(Duration(milliseconds: 3500), () {
      ctx.dispatch(BootActionCreator.onFreshAniState(false));
    });
  }

  // 保证选线在登录之前,选线必须成功才能进入app
  await selectLine(ctx.context);
  var nowTime = DateTime.now().millisecondsSinceEpoch;
  var duration = (nowTime - lastEventTime) ~/ 1000;
  lastEventTime = nowTime;
  umplus.event(umplus.Events.selectLine,
      data: {'duration': duration}).sendEvent();
  log.d('[LINE] 选线成功 fast host:${hosts.host}');

  // 这里init net，因为这里需要line.domain
  net.init(hosts.host);
  netManager.init(hosts.host);
  await version.init();
  ctx.state.version = version.versionLocal;

  //检查token是否存在，没有则调用登录
  var token = await getToken();
  if (token == null || token.isEmpty) {
    //登陆必须成功才能进入app
    await _login(ctx.context);
    nowTime = DateTime.now().millisecondsSinceEpoch;
    duration = (nowTime - lastEventTime) ~/ 1000;
    lastEventTime = nowTime;
    umplus.event(umplus.Events.login, data: {'duration': duration}).sendEvent();
  } else {
    _reqUserInfo();
  }

  //登录之后拿到token才能获取版本号，版本号必须拿到才能进入app
  await initUpdater(ctx.context);
  if (version.needUpdate) {
    await showUpdatePage(ctx.context);
  }
  nowTime = DateTime.now().millisecondsSinceEpoch;
  duration = (nowTime - lastEventTime) ~/ 1000;
  lastEventTime = nowTime;
  umplus.event(umplus.Events.update, data: {'duration': duration}).sendEvent();
  //开机广告
  await getAppAds(action, ctx);
  umplus.event(umplus.Events.bootPage).sendEvent();
  //获取推广广告数据
  await getSpreadData();
  //公告
  await getNoticeInfo();

  await _getImgDomain();

  await sendWalletNet();
}

void _onDispose(Action action, Context<BootState> ctx) {
  log.i("boot page dispose");
  freshBootPageEventBus.destroy();
  freshBootPageEventBus = null;
}

//****************网络**************************** */
_reqUserInfo() async {
  await net.request(Routers.EDIT_USER_INFO_POST,
      args: {"lastLoginTime": DateTime.now().millisecondsSinceEpoch});
}

/// 图片域名
_getImgDomain() async {
  var resp = await net.request(Routers.CDN_LIST, args: {"type": 2});
  if (resp.code != 200) {
    Future.delayed(Duration(milliseconds: 500), () {
      return _getImgDomain();
    });
  }
  if (resp.data == null) return;
  var map = resp.data as List;
  if (map.length == 0) return;

  var domain = map[0]["domain"] as String;

  setImgDomain(domain);
}
