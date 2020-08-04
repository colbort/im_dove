import 'dart:convert';

import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/page/main_mine_page/effect.dart';
import 'package:app/page/wallet_page/effect.dart';
import 'package:app/page/webview_page/view.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/log.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:url_launcher/url_launcher.dart';
import 'action.dart';
import 'purchase_vip/purchase_vip.dart';
import 'state.dart';

Effect<VipNewState> buildEffect() {
  return combineEffects(<Object, Effect<VipNewState>>{
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
    VipActionCreator.onRechargeSubmit: _onRechargeSubmit,
  });
}

/// 獲取VIP
Future<String> _getNickVIPlevel() async {
  String json = await ls.get(StorageKeys.USER_INFO);
  if (!(json is String)) return '';
  Map m = jsonDecode(json);
  if (!(m is Map)) return '';
  String nickVIPlevel = m['level'].toString();
  if (!(nickVIPlevel is String)) return '';
  return nickVIPlevel;
}

void _init(Action action, Context<VipNewState> ctx) async {
  var vip = await _getNickVIPlevel();
  ctx.dispatch(VipActionCreator.viplevel(int.parse(vip)));

  // var _vipList = await net.request(Routers.VIP_GETALLLIST_GET, method: 'get');
  // if (_vipList.code == 200) {
  //   ctx.dispatch(VipActionCreator.saveList(_vipList.data['formal']));
  // }
  try {
    var bean = await netManager.client.getAllVipInfo();
    ctx.dispatch(VipActionCreator.onGetVipInfoOkay(bean?.formal));
  } catch (e) {
    l.e("chargevip", "error:$e");
  }
  try {
    var bean = await netManager.client.getPayType();
    ctx.dispatch(VipActionCreator.onGetChargeInfoOkay(bean));
  } catch (e) {
    l.e("chargevip", "error:$e");
  }
  var wallet = await sendWalletNet();
  if (wallet != null) {
    ctx.dispatch(VipActionCreator.getWallet(
        {"balance": wallet.balance, "paoHua": wallet.paoHua}));
  }
}

void _dispose(Action action, Context<VipNewState> ctx) async {
  flutterWebviewPlugin.show();
  updateUserInfo.fire(null);
}

void _onRechargeSubmit(Action action, Context<VipNewState> ctx) async {
  int id = action.payload['id'];
  String money = action.payload['money'];
  int payType = action.payload['payType'];

  var result = await net.request(Routers.RECHARGE_SUBMIT_POST, args: {
    'id': id,
    'money': double.parse(money),
    'payType': payType,
    'typ': 2,
  });

  /// 购买VIP回调
  if (payType == 0) {
    showDialog(
        context: ctx.context,
        builder: (BuildContext context) => PurchaseSuccess(
            text: result.code == 200 ? Lang.BUYSUCC : Lang.BUYFAIL));
  } else {
    if (result.code == 200) {
      String url = result.data['url'];
      bool openNewBrowser = result.data['openNewBrowser']; //  true打开系统浏览器
      launch(url,
          forceSafariVC: !openNewBrowser, forceWebView: !openNewBrowser);

      // Navigator.of(ctx.context).pushNamed('WebviewPage', arguments: {
      //   'url': url,
      // });
    } else {
      if (result.data is Map) {
        String msg = result.data['msg'];
        if (msg == null) msg = Lang.zCz + '失败';
        showDialog(
            context: ctx.context,
            builder: (BuildContext context) => PurchaseSuccess(text: msg));
      }
    }
  }
}
