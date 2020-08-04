import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/pojo/vip_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum VipAction {
  getVipInfoOkay,
  getChargeInfoOkay,
  getWallet,
  selectCard,
  onRechargeSubmit, //  充值请求
  viplevel,
}

class VipActionCreator {
  static Action onGetVipInfoOkay(List<VipItemInfo> vipItems) {
    return Action(VipAction.getVipInfoOkay, payload: vipItems);
  }

  static Action onGetChargeInfoOkay(List<ChargeItemBean> chargeItems) {
    return Action(VipAction.getChargeInfoOkay, payload: chargeItems);
  }

  static Action getWallet(Map map) {
    return Action(VipAction.getWallet, payload: map);
  }

  static Action selectCard(int index) {
    return Action(VipAction.selectCard, payload: index);
  }

  static Action viplevel(int index) {
    return Action(VipAction.viplevel, payload: index);
  }

  static Action onRechargeSubmit(int id, String money, int payType) {
    return Action(VipActionCreator.onRechargeSubmit,
        payload: {'id': id, 'money': money, 'payType': payType});
  }
}
