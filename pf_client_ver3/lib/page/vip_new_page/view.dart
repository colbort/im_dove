import 'package:app/page/vip_new_page/components/rights.dart';
import 'package:app/page/vip_new_page/purchase_vip/purchase_vip.dart';
import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/pojo/pay_type.dart';
import 'package:app/pojo/vip_item_bean.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/text_util.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
// import 'package:app/lang/lang.dart';
import '../../widget/common/BasePage.dart';
import 'components/head.dart';
import 'components/vipCard.dart';
import 'state.dart';

Widget buildView(
    VipNewState state, Dispatch dispatch, ViewService viewService) {
  return _VipPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

/// [cardId] 映射
Map<int, dynamic> mapVipItem = {
  1: {
    'color': Color(0xff68C5F4),
    'name': '月',
    'selectedImg': 'assets/vip/month.png',
    'borderColor': Color(0xff68C5F4),
  },
  2: {
    'color': Color(0xff9F8FF0),
    'name': '季',
    'selectedImg': 'assets/vip/season.png',
    'borderColor': Color(0xffC4B9FC),
  },
  3: {
    'color': Color(0xffF88DB4),
    'name': '年',
    'selectedImg': 'assets/vip/year.png',
    'borderColor': Color(0xffFC9FC1),
  }
};

class _VipPageView extends BasePage with BasicPage {
  final VipNewState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _VipPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => 'VIP';

  VipItem _getVipItem(int cardId) {
    if ((state.vipInfos?.length ?? 0) == 0) return VipItem(0);
    var currentItem =
        state.vipInfos.firstWhere((info) => info.cardId == cardId);
    var uiItem = mapVipItem[cardId];
    return VipItem(
      cardId,
      color: uiItem != null ? uiItem['color'] : Colors.white,
      name: uiItem != null ? uiItem['name'] : '',
      realPrice: getRealPrice(currentItem),
      oldPrice: getOldPrice(currentItem),
      selectedImg: uiItem != null ? uiItem['selectedImg'] : '',
      borderColor: uiItem != null ? uiItem['borderColor'] : Colors.white,
      day: currentItem.dayCount,
      isSelected: state.selectedCard == cardId,
    );
  }

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: s.realH(9),
          horizontal: s.realW(15),
        ),
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.05),
              Colors.white,
            ],
            stops: [
              0.45,
              0.45,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            state.viplevel > 0 ? viphead(state) : Container(),
            Container(
              margin: EdgeInsets.symmetric(vertical: s.realH(7)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if ((state.vipInfos?.length ?? 0) > 0)
                      ...state.vipInfos.map((info) {
                        return vipCard(_getVipItem(info.cardId), dispatch);
                      })
                    else
                      Container(
                        height: s.realH(178),
                      )
                  ],
                ),
              ),
            ),
            rightCard(_getVipItem(state.selectedCard),
                _getVipItem(state.selectedCard).day.toString(), onTap: () {
              var vipInfo = state.vipInfos[state.selectedCard - 1];
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: viewService.context,
                builder: (context) => PurchaseVIP(
                  dispatch: dispatch,
                  viewService: viewService,
                  state: state,
                  vipInfo: vipInfo,
                  payTypes:
                      _getPayTypes(getRealPrice(vipInfo), state.chargeItems),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 获取某个价格的支付类型
List<PayType> _getPayTypes(String price, List<ChargeItemBean> charList) {
  if (charList == null || charList.length <= 0) return null;
  for (var item in charList) {
    if (item.money == price) return item.types;
  }
  return null;
}

/// 获取vip真实的价格
String getRealPrice(VipItemInfo vif) {
  if (null == vif) return '';
  if (TextUtil.isNotEmpty(vif.moneyPrePrice) && vif.moneyPrePrice != "0") {
    return vif.moneyPrePrice;
  } else {
    return vif.money;
  }
}

String getOldPrice(VipItemInfo vif) {
  if (null == vif) return '';
  if (TextUtil.isEmpty(vif.money)) return '';
  if (TextUtil.isEmpty(vif.moneyPrePrice) || vif.moneyPrePrice == "0")
    return '';
  return vif.money;
}
