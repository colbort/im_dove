import 'package:app/storage/cache.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

Effect<WalletState> buildEffect() {
  return combineEffects(<Object, Effect<WalletState>>{
    Lifecycle.initState: _initState,
    WalletAction.onGetWallet: _onGetWallet,
    WalletAction.onGetAllTransHistory: _onGetAllTransHistory,
    WalletAction.onRefresh: _onRefresh,
  });
}

void _initState(Action action, Context<WalletState> ctx) {
  ctx.dispatch(WalletActionCreator.onGetWallet());
  ctx.dispatch(WalletActionCreator.onGetAllTransHistory(1));

  if (ctx.state.showCharge) {
    Future.delayed(Duration(milliseconds: 250)).then((_) {
      // FIXME TORY there need fix
      // showModalBottomSheet(
      //   backgroundColor: Colors.transparent,
      //   context: ctx.context,
      //   builder: (context) => ChargeCategory(),
      // );
    });
  }
}

void _onGetWallet(Action action, Context<WalletState> ctx) async {
  var data = await sendWalletNet();
  ctx.dispatch(WalletActionCreator.getWallet(data.balance, data.paoHua));
}

/// 加载
void _onGetAllTransHistory(Action action, Context<WalletState> ctx) async {
  // int pageIndex = action.payload['pageIndex'];
  var resp = await net.request(Routers.WALLET_GETALLTRANSHISTORY_GET,
      params: action.payload, method: 'get');
  if (resp.code != 200) return;
  // data  map
  // total int
  var data = resp.data["data"];
  //保存钱包交易记录条数
  ls.save(StorageKeys.WALLET_TRANSITION,
      data is List ? data.length.toString() : '0');
  ctx.dispatch(
      WalletActionCreator.getAllTransHistory(data != null ? data : []));
}

/// 刷新
void _onRefresh(Action action, Context<WalletState> ctx) async {
  // int pageIndex = action.payload['pageIndex'];
  var resp = await net.request(Routers.WALLET_GETALLTRANSHISTORY_GET,
      params: action.payload, method: 'get');
  if (resp.code != 200) return;

  // data  map
  // total int
  var data = resp.data["data"];
  //保存钱包交易记录条数
  ls.save(StorageKeys.WALLET_TRANSITION,
      data is List ? data.length.toString() : '0');
  if (data != null) {
    ctx.dispatch(WalletActionCreator.refresh(data));
  }
}

/// 钱包数据
Future<WalletData> sendWalletNet() async {
  var resp = await net.request(Routers.WALLET_GETWALLET_GET, method: 'get');
  if (resp.code != 200) return WalletData();

  var balance = double.parse(resp.data['balance']);
  var paoHua = double.parse(resp.data['paoHua']);
  var d = WalletData();
  d.balance = balance;
  d.paoHua = paoHua;
  saveWalletData(d);
  return d;
}

class WalletData {
  double balance = 0.0;
  double paoHua = 0.0;
}
