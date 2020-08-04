import 'package:fish_redux/fish_redux.dart';

class WalletState implements Cloneable<WalletState> {
  var balance = .0;
  var paoHua = .0;
  var data = List();
  var pageIndex = 1;
  var isInit = true;
  bool showCharge = false;

  @override
  WalletState clone() {
    return WalletState()
      ..balance = balance
      ..paoHua = paoHua
      ..data = data
      ..isInit = isInit
      ..pageIndex = pageIndex
      ..showCharge = showCharge;
  }
}

WalletState initState(Map<String, dynamic> args) {
  var state = WalletState();
  if (args is Map) {
    state.showCharge = args['showCharge'];
  }
  return state;
}
