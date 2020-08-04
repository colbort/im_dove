import 'package:app/pojo/charge_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

enum AlichargeAction {
  getPayItemsOkay, // UI 获取充值items成功
  itemSelectUI,
}

class AlichargeActionCreator {
  static Action onGetPayItemOkay(List<ChargeItemBean> data) {
    return Action(AlichargeAction.getPayItemsOkay, payload: data);
  }

  static Action onItemSelectUI(int index) {
    return Action(AlichargeAction.itemSelectUI, payload: index);
  }
}
