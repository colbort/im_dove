import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VipNewState> buildReducer() {
  return asReducer(
    <Object, Reducer<VipNewState>>{
      VipAction.getVipInfoOkay: _onGetVipInfoOkay,
      VipAction.getChargeInfoOkay: _onGetChargeInfoOkay,
      VipAction.getWallet: _getWallet,
      VipAction.selectCard: _selectCard,
      VipAction.viplevel: _viplevel,
    },
  );
}

VipNewState _onGetVipInfoOkay(VipNewState state, Action action) {
  return state.clone()..vipInfos = action.payload;
}

VipNewState _onGetChargeInfoOkay(VipNewState state, Action action) {
  return state.clone()..chargeItems = action.payload;
}

VipNewState _selectCard(VipNewState state, Action action) {
  final newState = state.clone();
  newState.selectedCard = action.payload;
  return newState;
}

VipNewState _viplevel(VipNewState state, Action action) {
  final newState = state.clone();
  newState.viplevel = action.payload;
  return newState;
}

VipNewState _getWallet(VipNewState state, Action action) {
  String balance = action.payload['balance'];
  String paoHua = action.payload['paoHua'];
  final newState = state.clone()
    ..balance = balance
    ..paoHua = paoHua;
  return newState;
}
