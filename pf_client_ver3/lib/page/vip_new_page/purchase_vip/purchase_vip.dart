import 'package:app/lang/lang.dart';
import 'package:app/page/vip_new_page/view.dart';
import 'package:app/pojo/pay_type.dart';
import 'package:app/pojo/vip_item_bean.dart';
import 'package:app/utils/pay_helper.dart';
import 'package:app/widget/common/toast.dart';
import 'package:decimal/decimal.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../state.dart';

class PurchaseVIP extends StatefulWidget {
  final Dispatch dispatch;
  final ViewService viewService;
  final VipNewState state;
  final VipItemInfo vipInfo;
  final List<PayType> payTypes;

  PurchaseVIP(
      {this.dispatch,
      this.viewService,
      this.state,
      this.vipInfo,
      this.payTypes});

  @override
  State<StatefulWidget> createState() {
    return _PurchaseVIPState();
  }
}

/// 点击卡片后底部弹出的购买VIP
class _PurchaseVIPState extends State<PurchaseVIP> {
  bool isPaying;
  String selectedTitle = Lang.qianBao;

  _PurchaseVIPState();

  @override
  void initState() {
    super.initState();
    isPaying = false;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: 363,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _label(context),
            SizedBox(height: 20),
            // _row(context, checked: false),
            _genRow(context,
                imageName: 'assets/mine/cz_official.svg',
                title: Lang.qianBao,
                content: '',
                checked: selectedTitle == Lang.qianBao),

            ..._genListWidget(context, widget.payTypes),

            SizedBox(height: 20),
            _button(context),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 6,
          height: 25,
          child: Container(
            color: Color.fromRGBO(250, 221, 45, 1),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            Lang.VIP_BUY_METHOD,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        InkWell(
          child: Icon(Icons.clear),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  List<Widget> _genListWidget(BuildContext context, List<PayType> payTypes) {
    if (null == payTypes || payTypes.length <= 0) return <Widget>[];
    return List.generate(payTypes?.length ?? 0, (index) {
      return _genRowByPayType(context, payTypes[index]);
    });
  }

  Widget _genRowByPayType(BuildContext context, PayType payType) {
    var payName = getPayTitleBySign(payType.type);
    return _genRow(context,
        imageName: getPayImgPathBySign(payType.type),
        title: payName,
        checked: selectedTitle == payName);
  }

  /// 构建一行内容
  Widget _genRow(BuildContext context,
      {String imageName, String title, String content, bool checked}) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                imageName,
                width: 30,
                height: 30,
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: content == null
                    ? Container()
                    : Text(
                        Lang.val(Lang.VIP_BALANCE,
                            args: [widget.state.balance]),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(135, 135, 135, 1),
                        ),
                      ),
              ),
              SvgPicture.asset(
                checked ? 'assets/vip/checked.svg' : 'assets/vip/unchecked.svg',
                width: 22,
                height: 22,
              ),
            ],
          ),
          onTap: () {
            didClickRow(title);
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 40,
            child: RaisedButton(
              color: Color.fromRGBO(240, 65, 90, 1),
              shape: StadiumBorder(),
              child: Text(
                isPaying ? Lang.chargePostWating : Lang.VIP_CONFIRM,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: didClickConfirm,
            ),
          ),
        ),
      ],
    );
  }

  /// 点击某一行
  void didClickRow(String title) {
    print(title);
    selectedTitle = title;
    setState(() {});
  }

  /// 点击确认
  void didClickConfirm() async {
    int payType = PAYTYPE_BALANCE;
    if (selectedTitle == Lang.walletBao) {
      payType = PAYTYPE_ALI;
    } else if (selectedTitle == Lang.walletYin) {
      payType = PAYTYPE_UNION;
    } else if (selectedTitle == Lang.walletOfficial) {
      payType = PAYTYPE_WX;
    }
    if (isPaying) {
      showToast(Lang.PAYING_TIP);
      return;
    }

    int cardId = widget.vipInfo.cardId;
    var realPrice = getRealPrice(widget.vipInfo);
    if (payType == PAYTYPE_BALANCE &&
        Decimal.parse(widget.state.balance) > Decimal.parse(realPrice)) {
      //  提示充值
      insuficientBalance();
      return;
    }
    setState(() {
      isPaying = true;
    });

    await doCharge(context, realPrice, payType, getSignByPayType(payType),
        BUYTYPE_VIP, cardId);
    setState(() {
      isPaying = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      isPaying = false;
    });
  }

  /// 余额不足，请充值
  void insuficientBalance() {
    showDialog(
        context: widget.viewService.context,
        builder: (BuildContext context) {
          return InsuficientBalance();
        });
  }
}

/// 余额不足，请充值
class InsuficientBalance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(Lang.vipInsuficientBalance),
      actions: <Widget>[
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(Lang.VIP_GIVE_UP),
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('WalletPage');
          },
          child: Text(
            Lang.vipGoCharge,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

/// 购买成功
class PurchaseSuccess extends StatelessWidget {
  final String text;

  PurchaseSuccess({this.text});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(text),
    );
  }
}
