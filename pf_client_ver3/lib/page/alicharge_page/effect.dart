import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/utils/log.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<AlichargeState> buildEffect() {
  return combineEffects(<Object, Effect<AlichargeState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<AlichargeState> ctx) async {
  var list = await getPayItem(ctx.context);
  ctx.dispatch(AlichargeActionCreator.onGetPayItemOkay(list));
}

Future<List<ChargeItemBean>> getPayItem(BuildContext context) async {
  List<ChargeItemBean> chargeItemBeans;
  try {
    chargeItemBeans = await netManager.client.getPayType();
  } catch (e) {
    l.e("test", "error:$e");
  }
  chargeItemBeans?.removeWhere((item) {
    return (item?.types?.length ?? 0) <= 0;
  });
  if (null == chargeItemBeans || chargeItemBeans.length <= 0) {
    await showConfirm(context, child: Text(Lang.WANGLUOCUOWU));
  }
  return chargeItemBeans;
}

// void _onRechargeSubmit(Action action, Context<AlichargeState> ctx) async {
//   // 充值中
//   var money = action.payload['money'];
//   var payType = action.payload['payType'];
//   ctx.dispatch(AlichargeActionCreator.onChangePayStatus(true));

//   var resp = await net.request(Routers.RECHARGE_SUBMIT_POST,
//       args: {'id': null, 'money': money, 'payType': payType, 'typ': 1});
//   ctx.dispatch(AlichargeActionCreator.onChangePayStatus(false));
//   if (resp.code == 200) {
//     String url = resp.data['url'];
//     bool openNewBrowser = resp.data['openNewBrowser']; //  true打开系统浏览器
//     launch(url, forceSafariVC: !openNewBrowser, forceWebView: !openNewBrowser);

//     // Navigator.of(ctx.context).pushNamed('WebviewPage', arguments: {
//     //   'url': url,
//     // });
//   } else {
//     if (resp.data is Map) {
//       String msg = resp.data['msg'];
//       if (msg == null) msg = Lang.zCz + '失败';
//       showToast(msg, type: ToastType.negative);
//     }
//   }
// }
