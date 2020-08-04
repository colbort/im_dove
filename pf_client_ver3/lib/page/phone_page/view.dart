import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/widget/common/BasePage.dart';
import 'package:app/lang/lang.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(PhoneState state, Dispatch dispatch, ViewService viewService) {
  return state.showLeading
      ? _PhonePage(state: state, dispatch: dispatch, viewService: viewService)
      : WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _PhonePage(
              state: state, dispatch: dispatch, viewService: viewService),
        );
}

class _PhonePage extends BasePage with BasicPage {
  final PhoneState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _PhonePage({Key key, this.state, this.dispatch, this.viewService})
      : super(key: key);

  @override
  String screenName() =>
      state.showLeading ? Lang.PHONE_PHONE : Lang.PHONE_RELOG;

  @override
  Widget leading(context) => state.showLeading
      ? IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
          onPressed: () => Navigator.of(context).pop(),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    var backColor = Colors.white;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                elevation: 0,
                actions: actions(),
                title: Text(
                  screenName(),
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: backColor,
                leading: leading(context)),
            body: Container(
              child: body(),
              color: Colors.white,
            ),
            floatingActionButton: fab(),
          ),
        ));
  }

  @override
  Widget body() {
    return InkWell(
      onTap: () {
        state.areaNode.unfocus();
        state.phoneNode.unfocus();
        state.captchaNode.unfocus();
        state.inviteCodeNode.unfocus();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
        child: Column(
          children: <Widget>[
            _row0(),
            _row1(),
            // _row2(),
            SizedBox(height: 140),
            _bindButton(),
          ],
        ),
      ),
    );
  }

  /// 请输入手机号
  Widget _row0() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 45,
          child: TextField(
            focusNode: state.areaNode,
            keyboardType: TextInputType.numberWithOptions(),
            controller: state.areaController,
            decoration: InputDecoration(
              hintText: Lang.PHONE_AREA,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            focusNode: state.phoneNode,
            keyboardType: TextInputType.numberWithOptions(),
            controller: state.phoneController,
            decoration: InputDecoration(
              hintText: Lang.PHONE_INPUTPHONE,
            ),
          ),
        ),
      ],
    );
  }

  /// 请输入验证码
  Widget _row1() {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: <Widget>[
        TextField(
          focusNode: state.captchaNode,
          keyboardType: TextInputType.numberWithOptions(),
          controller: state.captchaController,
          decoration: InputDecoration(
            hintText: Lang.PHONE_INPUTCODE,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: state.countdown == -1
                ? Color.fromRGBO(240, 65, 90, 1)
                : Colors.grey,
          ),
          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: state.countdown == -1
              ? _countDownButton()
              : _countDownGrayButton(state.countdown),
        ),
      ],
    );
  }

  /// 邀请码
  // Widget _row2() {
  //   return TextField(
  //     focusNode: state.inviteCodeNode,
  //     keyboardType: TextInputType.numberWithOptions(),
  //     controller: state.inviteCodeController,
  //     decoration: InputDecoration(
  //       hintText: '邀请码（选填）',
  //     ),
  //   );
  // }

  Widget _countDownGrayButton(int countdown) {
    return GestureDetector(
      child: Text(
        '${countdown}s' + Lang.PHONE_REGET,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _countDownButton() {
    return GestureDetector(
      child: Text(
        Lang.PHONE_GETCODE,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        String area = state.areaController.text;
        String phone = state.phoneController.text;

        String oldPhone = state.oldPhone;
        if (oldPhone != null &&
            oldPhone.isNotEmpty &&
            (phone == oldPhone || oldPhone.endsWith(phone))) {
          showToast(Lang.OPER_BINDED_MOBILE, type: ToastType.negative);
          return;
        }

        if (state.showLeading) {
          dispatch(PhoneActionCreator.onMobileAction(area, phone));
        } else {
          dispatch(
              PhoneActionCreator.mobileAction(PhoneStateType.switchAccount));
        }

        dispatch(PhoneActionCreator.onGetCaptcha(area, phone));
      },
    );
  }

  /// 绑定手机号
  Widget _bindButton() {
    if (state.type == PhoneStateType.none) {
      return Row();
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Color.fromRGBO(240, 65, 90, 1),
            shape: StadiumBorder(),
            onPressed: () {
              String area = state.areaController.text;
              String phone = state.phoneController.text;
              String captcha = state.captchaController.text;
              String inviteCode = state.inviteCodeController.text;
              dispatch(
                  PhoneActionCreator.onBind(area, phone, captcha, inviteCode));
            },
            child: Text(
              _getButtonTitle(state.type),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getButtonTitle(PhoneStateType type) {
    String s;
    switch (type) {
      case PhoneStateType.bindPhone:
        s = Lang.PHONE_BINDPHONE;
        break;
      case PhoneStateType.switchAccount:
        s = Lang.PHONE_SWICHPHONE;
        break;
      case PhoneStateType.switchPhone:
        s = Lang.PHONE_CHGPHONE;
        break;
      default:
        s = '';
        break;
    }
    return s;
  }
}
