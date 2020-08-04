import 'package:app/lang/lang.dart';
import 'package:app/page/wallet_page/action.dart';
import 'package:app/utils/comm.dart';
import 'package:app/widget/common/defaultWidget.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/common/BasePage.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'charge_category/wallet_page_cell.dart';
import 'state.dart';

Widget buildView(
    WalletState state, Dispatch dispatch, ViewService viewService) {
  return _WalletPage(
      state: state, dispatch: dispatch, viewService: viewService);
}

/// 钱包
class _WalletPage extends BasePage with BasicPage {
  final WalletState state;
  final Dispatch dispatch;
  final ViewService viewService;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _WalletPage({Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  String screenName() => Lang.vipWallet;

  _onRefresh() async {
    await dispatch(WalletActionCreator.onRefresh());
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    await dispatch(WalletActionCreator.onGetAllTransHistory(state.pageIndex));
    _refreshController.loadComplete();
  }

  @override
  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _label(),
          _row(),
          SizedBox(height: 20),
          Divider(
            thickness: 1,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  Lang.WALLET_TRADE_RECORD,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
          // Expanded(
          //   child: Container(
          //     child: Text('暂无数据1s'),
          //   ),
          // ),
          state.data.length <= 0
              ? Expanded(
                  child: state.isInit
                      ? new CupertinoActivityIndicator()
                      : Container(
                          child: Center(
                            child: showDefaultWidget(DefaultType.noData),
                          ),
                        ),
                )
              : Expanded(
                  child: pullRefresh(
                    refreshController: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Map map = state.data[index];
                        return WalletPageCell(map: map);
                      },
                      itemCount: state.data.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _label() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
          state.balance.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Image.asset(
      //       'assets/mine/balance_currency.png',
      //       width: 20,
      //       height: 20,
      //     ),
      //     Container(
      //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      //       child: Text(
      //         state.balance.toStringAsFixed(2),
      //         style: TextStyle(
      //           fontSize: 34,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  /// 充值
  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(17)),
          child: SizedBox(
            width: 132,
            height: 34,
            child: FlatButton(
              color: Color.fromRGBO(53, 163, 252, 1),
              child: Text(
                Lang.walletCharge,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await Navigator.of(viewService.context)
                    .pushNamed(page_alichargePage);
                // doRefresh here 从新获取一次钱包的钱
                dispatch(WalletActionCreator.onGetWallet());
              },
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(17)),
          child: SizedBox(
            width: 132,
            height: 34,
            child: FlatButton(
              color: Color.fromRGBO(250, 221, 64, 1),
              child: Text(
                Lang.walletWithdraw,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                // Navigator.of(viewService.context).pushNamed('AlichargePage');
                showToast(Lang.IN_DEVELOPMENT, type: ToastType.negative);

                // showDialog(
                //   context: viewService.context,
                //   builder: (BuildContext context) {
                //     return CupertinoAlertDialog(
                //       title: Text(Lang.IN_DEVELOPMENT),
                //     );
                //   },
                // );
              },
            ),
          ),
        ),
      ],
    );
  }
}
