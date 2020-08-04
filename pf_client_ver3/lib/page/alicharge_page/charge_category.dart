import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net2/net_manager.dart';
import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/pojo/pay_suc_bean.dart';
import 'package:app/pojo/pay_type.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/pay_helper.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:app/widget/common/toast/src/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 选择充值方式的底部弹窗
class ChargeCategory extends StatefulWidget {
  final ChargeItemBean itemBean;

  const ChargeCategory(this.itemBean, {Key key}) : super(key: key);
  @override
  _ChargeCategoryState createState() => _ChargeCategoryState();
}

class _ChargeCategoryState extends State<ChargeCategory> {
  int selectedPayTypeIndex = -1;
  bool isPaying = false;
  @override
  Widget build(BuildContext context) {
    return isPaying
        ? showLoadingWidget(true, 20)
        : ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              height: 363,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _label(context),
                  SizedBox(height: 40),
                  _gridView(),
                  Expanded(child: Container()),
                  _button(context),
                  SizedBox(height: 40),
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
            Lang.walletChargeWay,
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

  Widget _getChildWidget(PayType payType, int index) {
    if (null == payType) return Container();
    return InkWell(
      onTap: () {
        setState(() {
          selectedPayTypeIndex = index;
        });
      },
      child: Container(
        color: selectedPayTypeIndex == index
            ? Color.fromRGBO(234, 234, 234, 1)
            : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageLoader.withP(
                    ImageType.IMAGE_SVG, getPayImgPathBySign(payType.type),
                    width: 40, height: 40)
                .load(),
            SizedBox(height: 15),
            Text(
              getPayTitleBySign(payType.type),
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: widget?.itemBean?.types?.length ?? 0,
      childAspectRatio: 1.5,
      crossAxisSpacing: 5,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(widget?.itemBean?.types?.length ?? 0, (index) {
        return _getChildWidget(widget.itemBean.types[index], index);
      }),
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
                null != widget.itemBean
                    ? widget.itemBean.money
                    : Lang.VIP_CONFIRM,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (selectedPayTypeIndex == -1) {
                  showToast(Lang.CHOOSE_A_CHARGET_TYPE_TIP);
                  return;
                }
                if (isPaying) {
                  showToast(Lang.PAYING_TIP);
                  return;
                }
                setState(() {
                  isPaying = true;
                });
                var payType = widget.itemBean.types[selectedPayTypeIndex];
                await doCharge(
                    context,
                    widget.itemBean.money,
                    getPayTypeBySign(payType.type),
                    payType.type,
                    BUYTYPE_BALANCE);
                setState(() {
                  isPaying = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
