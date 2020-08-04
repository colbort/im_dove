import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/pojo/vip_item_bean.dart';
import 'package:fish_redux/fish_redux.dart';

class VipNewState implements Cloneable<VipNewState> {
  /// vip等级的充值信息
  List<VipItemInfo> vipInfos;
  // 可以充值的金额
  List<ChargeItemBean> chargeItems;
  var balance = '0';
  var paoHua = '0';
  int selectedCard = 1;
  int viplevel = 0;

  @override
  VipNewState clone() {
    return VipNewState()
      ..vipInfos = vipInfos
      ..chargeItems = chargeItems
      ..balance = balance
      ..selectedCard = selectedCard
      ..paoHua = paoHua
      ..viplevel = viplevel;
  }
}

VipNewState initState(dynamic args) {
  return VipNewState();
}
