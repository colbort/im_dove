import 'package:app/pojo/charge_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AlichargeState> buildReducer() {
  return asReducer(
    <Object, Reducer<AlichargeState>>{
      AlichargeAction.getPayItemsOkay: _onGetChargeItemsOkay,
      AlichargeAction.itemSelectUI: _onItemSelectUI,
    },
  );
}

/// 获取充值item成功
AlichargeState _onGetChargeItemsOkay(AlichargeState state, Action action) {
  var chargeItems = action.payload as List<ChargeItemBean>;
  return state.clone()..chargeItems = chargeItems;
}

AlichargeState _onItemSelectUI(AlichargeState state, Action action) {
  var selectItem = action.payload as int;
  return state.clone()..selectItem = selectItem;
}
