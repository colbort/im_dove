import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/toast/src/core/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/widget/common/BasePage.dart';

import 'action.dart';
import 'charge_category.dart';
import 'state.dart';

Widget buildView(
    AlichargeState state, Dispatch dispatch, ViewService viewService) {
  return _AlichargePage(
      state: state, dispatch: dispatch, viewService: viewService);
}

class _AlichargePage extends BasePage with BasicPage {
  final AlichargeState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _AlichargePage({Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  String screenName() {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              title: Text(
                screenName(),
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon:
                    Icon(Icons.navigate_before, color: Colors.black, size: 40),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              child: body(),
              color: Colors.white,
            ),
          ),
        ));
  }

  @override
  Widget body() {
    return InkWell(
      onTap: () {
        state.focusNode.unfocus();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                Lang.chargeAmount,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            _gridView(),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            //   child: Text(
            //     Lang.chargeOtherMoney,
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            Expanded(child: Container()),
            _button(),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
    return (state.chargeItems?.length ?? 0) <= 0
        ? Container(
            margin: EdgeInsets.only(top: Dimens.pt100),
            alignment: Alignment.center,
            child: showLoadingWidget(true))
        : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.0 / 1.0,
            ),
            itemCount: state.chargeItems?.length ?? 0,
            itemBuilder: (ctx, index) {
              return RaisedButton(
                color: index == state.selectItem
                    ? Colors.redAccent
                    : Color.fromRGBO(250, 221, 45, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  Lang.val(Lang.CHARGE_YUAN,
                      args: [state.chargeItems[index].money]),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  // 用户选择了充值项目
                  dispatch(AlichargeActionCreator.onItemSelectUI(index));
                },
              );
            },
          );
  }

  Widget _button() {
    return Row(children: <Widget>[
      Expanded(
        child: SizedBox(
            height: 40,
            child: RaisedButton(
              color: Color.fromRGBO(240, 65, 90, 1),
              shape: StadiumBorder(),
              child: Text(
                // state.selectItem >= 0
                //     ? state.chargeItems[state.selectItem].money
                //     :
                Lang.CHARGE_POST_REQUEST,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (state.selectItem < 0) {
                  showToast(Lang.CHOOSE_A_CHARGET_ITEM_TIP);
                  return;
                }
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: viewService.context,
                  builder: (context) =>
                      ChargeCategory(state.chargeItems[state.selectItem]),
                );
              },
            )),
      )
    ]);
  }
}
