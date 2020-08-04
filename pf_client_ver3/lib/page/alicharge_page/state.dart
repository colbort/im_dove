import 'package:app/pojo/charge_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class AlichargeState implements Cloneable<AlichargeState> {
  FocusNode focusNode = FocusNode();
  List<ChargeItemBean> chargeItems;
  int selectItem = -1;

  @override
  AlichargeState clone() {
    return AlichargeState()
      ..focusNode = focusNode
      ..chargeItems = chargeItems
      ..selectItem = selectItem;
  }
}

AlichargeState initState(Map<String, dynamic> args) {
  return AlichargeState()
    ..chargeItems = <ChargeItemBean>[]
    ..selectItem = -1;
}
