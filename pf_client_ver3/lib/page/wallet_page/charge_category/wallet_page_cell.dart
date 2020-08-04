import 'package:app/lang/lang.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class WalletPageCell extends StatelessWidget {
  final Map map;
  WalletPageCell({this.map});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context, width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  map['desc'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: (map['mark'] == 1 ? '+' : '-') + '${map['amount']}',
                      style: TextStyle(
                        color: map['mark'] == 1 ? Colors.blue : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: Lang.WALLET_YUAN,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                formatDate(DateTime.parse(map['createdAt']).toLocal(),
                    [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                _statusText(map),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusText(Map map) {
    int tranType = map['tranType'];
    String tranTypeText = '';
    if (tranType == 1) {
      tranTypeText = Lang.walletCharge;
    } else if (tranType == 2) {
      tranTypeText = Lang.WALLET_BUY_VIP;
    } else if (tranType == 3) {
      tranTypeText = Lang.walletWithdraw;
    } else if (tranType == 4) {
      tranTypeText = Lang.WALLET_EXCHANGE;
    } else if (tranType == 5) {
      tranTypeText = Lang.WALLET_PROFIT;
    } else if (tranType == 6) {
      tranTypeText = Lang.WALLET_BUY_VIDEO;
    } else if (tranType == 7) {
      tranTypeText = Lang.WALLET_VIDEO_PROFIT;
    }

    // int status = map['status'];
    // String statusText = '';
    // if (status == 0) {
    //   statusText = Lang.WALLET_IN;
    // } else if (status == 1) {
    //   statusText = Lang.WALLET_SUCCESS;
    // } else if (status == -1) {
    //   statusText = Lang.WALLET_FAILED;
    // }
    return tranTypeText;
  }
}
