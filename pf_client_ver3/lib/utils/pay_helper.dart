import 'package:app/config/image_cfg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/pojo/pay_suc_bean.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:app/widget/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'log.dart';

/// [payType] 支付类型
const int PAYTYPE_BALANCE = 0;
const int PAYTYPE_ALI = 1;
const int PAYTYPE_UNION = 2;
const int PAYTYPE_WX = 3;

/// [payTypeName] 支付类型的名称
const String PAY_SIGN_ALI = 'fixedAlipay';
const String PAY_SIGN_WX = 'fixedWechat';
const String PAY_SIGN_UNION = 'union';

/// [buyType] 购买/充值类型
const int BUYTYPE_BALANCE = 1;
const int BUYTYPE_VIP = 2;
const int BUYTYPE_PAOHUA = 3;

/// 从支付验签获取支付类型
int getPayTypeBySign(String sign) {
  if (TextUtil.isEmpty(sign)) return PAYTYPE_BALANCE;
  switch (sign) {
    case PAY_SIGN_ALI:
      return PAYTYPE_ALI;
    case PAY_SIGN_WX:
      return PAYTYPE_WX;
    case PAY_SIGN_UNION:
      return PAYTYPE_UNION;
    default:
      return PAYTYPE_BALANCE;
  }
}

/// 获取支付名称
String getPayTitleBySign(String sign) {
  switch (sign) {
    case PAY_SIGN_ALI:
      return Lang.walletBao; // 支付包
    case PAY_SIGN_WX:
      return Lang.walletOfficial; // 支付包
    case PAY_SIGN_UNION:
      return Lang.walletYin; // 支付包
    default:
      return '';
  }
}

/// 获取支付验签
String getSignByPayType(int payType) {
  switch (payType) {
    case PAYTYPE_ALI:
      return PAY_SIGN_ALI; // 支付包
    case PAYTYPE_WX:
      return PAY_SIGN_WX; // 支付包
    case PAYTYPE_UNION:
      return PAY_SIGN_UNION; // 支付包
    default:
      return '';
  }
}

/// 获取支付图标
String getPayImgPathBySign(String sign) {
  if (TextUtil.isEmpty(sign)) return null;
  switch (sign) {
    case PAY_SIGN_ALI:
      return ImgCfg.MINE_CZ_BAO; // 支付包
    case PAY_SIGN_WX:
      return ImgCfg.MINE_CZ_WX; // 支付包
    case PAY_SIGN_UNION:
      return ImgCfg.MINE_CZ_YIN; // 支付包
    default:
      return '';
  }
}

/// 简单的支付业务
Future<bool> doCharge(
    BuildContext context, String money, int payType, String sign, int buyType,
    [int cardId = 0]) async {
  if (TextUtil.isEmpty(money) || double.parse(money) <= 0) {
    l.e('charge', "param is error");
    showToast('param error money is $money');
    return false;
  }
  PaySucBean paySucBean;
  try {
    /// 充值购买余额
    paySucBean = await netManager.client
        .pay(double.parse(money), payType, sign, buyType, cardId);
  } catch (e) {
    l.e('charge', 'error:$e');
  }
  if (payType == PAYTYPE_BALANCE) {
    // 通过余额支付，不再走后面的复杂流程
    return true;
  }
  if (null == paySucBean) {
    await showConfirm(context, child: Text(Lang.WANGLUOCUOWU));
    return false;
  }
  if (TextUtil.isEmpty(paySucBean.url)) {
    l.e('charge', 'charge error url is empty');
    showToast('pay url is empty');
    return false;
  }
  await launch(paySucBean.url,
      forceSafariVC: !paySucBean.openNewBrowser,
      forceWebView: !paySucBean.openNewBrowser);
  return true;
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
}
