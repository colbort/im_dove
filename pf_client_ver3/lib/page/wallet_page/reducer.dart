import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WalletState> buildReducer() {
  return asReducer(
    <Object, Reducer<WalletState>>{
      WalletAction.getWallet: _getWallet,
      WalletAction.getAllTransHistory: _getAllTransHistory,
      WalletAction.refresh: _refresh,
    },
  );
}

WalletState _getWallet(WalletState state, Action action) {
  double balance = action.payload['balance'];
  double paoHua = action.payload['paoHua'];
  final newState = state.clone()
    ..balance = balance
    ..paoHua = paoHua;
  return newState;
}

WalletState _getAllTransHistory(WalletState state, Action action) {
  List data = action.payload['data'];

  var newState = state.clone();
  for (var i = 0; i < data.length; i++) {
    var d = data[i];
    if (newState.data.where((f) => f['ID'] == d['ID']).toList().length <= 0)
      newState.data.add(d);
  }
  newState.pageIndex = ((newState.data.length / 20).ceil()) + 1;
  newState.isInit = false;
  return newState;
}

WalletState _refresh(WalletState state, Action action) {
  List data = action.payload['data'];
  final newState = state.clone()
    ..data = data
    ..pageIndex = 1;
  return newState;
}
