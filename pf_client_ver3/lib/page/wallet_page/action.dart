import 'package:fish_redux/fish_redux.dart';

enum WalletAction {
  onGetWallet, // 获取钱包金额与泡花
  getWallet,
  onGetAllTransHistory, //  获取全部交易记录
  getAllTransHistory,

  /// 刷新
  onRefresh,
  refresh,
}

class WalletActionCreator {
  static onGetWallet() {
    return const Action(WalletAction.onGetWallet);
  }

  static getWallet(double balance, double paoHua) {
    return Action(WalletAction.getWallet, payload: {
      'balance': balance,
      'paoHua': paoHua,
    });
  }

  static onGetAllTransHistory(int pageIndex) {
    return Action(WalletAction.onGetAllTransHistory, payload: {
      'pageIndex': pageIndex,
      'pageSize': 20,
    });
  }

  static getAllTransHistory(List data) {
    return Action(WalletAction.getAllTransHistory, payload: {'data': data});
  }

  static onRefresh() {
    return const Action(WalletAction.onRefresh);
  }

  static refresh(List data) {
    return Action(WalletAction.refresh, payload: {'data': data});
  }
}
