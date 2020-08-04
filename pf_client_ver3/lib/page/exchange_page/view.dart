import 'package:app/page/main_mine_page/effect.dart';
import 'package:app/widget/common/toast.dart';
import 'package:app/widget/common/toast/oktoast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/net/net.dart';
import 'package:app/lang/lang.dart';
import 'package:app/widget/common/BasePage.dart';
import 'package:app/widget/common/commonBtn.dart';
import 'state.dart';

Widget buildView(
    ExchangeState state, Dispatch dispatch, ViewService viewService) {
  return _ExchangePage(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _ExchangePage extends BasePage with BasicPage {
  final ExchangeState state;
  final Dispatch dispatch;
  final ViewService viewService;
  final TextEditingController controller = TextEditingController();

  _ExchangePage({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => Lang.DUIHUANMA;
  @override
  Widget body() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 80),
            width: 224,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      offset: Offset(0, 4), //阴影xy轴偏移量
                      blurRadius: 8, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                      )
                ]),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
                hintText: Lang.QINGSHURUDUIHUANMA,
                hintStyle: TextStyle(
                    fontSize: 16, color: Color.fromRGBO(188, 188, 188, 1)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                filled: true,
                fillColor: Colors.white,
              ),
              // onChanged: (v) {
              //   print("onChange: $v");
              // },
            ),
          ),
          commonBtn(Lang.QUEDING, marginTop: 170, tabHandle: () async {
            if (controller.text.isEmpty) {
              // await showConfirm(viewService.context,
              //     title: Lang.WENXINTISHI, child: Text(Lang.DUIHUANMABUHEFA));
              showToast(Lang.DUIHUANMABUHEFA, type: ToastType.negative);
              return;
            }
            _useExchangeCode(viewService.context);
            // _checkExchangeCode();
          })
        ],
      ),
    );
  }

  // _checkExchangeCode() async {
  //   var resp = await net.request(Routers.CHECK_EXCHANGE_CODE,
  //       args: {'exchangeCode': controller.text});
  //   if (resp.code != 200) {
  //     showConfirm(viewService.context,
  //         title: Lang.WENXINTISHI,
  //         child: Text(resp.data != null && resp.data['msg'] != null
  //             ? resp.data['msg']
  //             : Lang.DUIHUANMAJIAOYANSHIBAI));
  //   } else if (resp.code == Code.SUCCESS) {
  //     bool ok = await showConfirm(viewService.context,
  //         title: Lang.WENXINTISHI,
  //         child: Center(
  //           child: Text(
  //             Lang.QUERENDUIHUAN + resp.data['exchangeLevel'] + "?",
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 color: Color.fromRGBO(54, 54, 54, 1),
  //                 fontWeight: FontWeight.w500),
  //           ),
  //         ));
  //     if (ok) {
  //       _useExchangeCode();
  //     }
  //   }
  // }

  _useExchangeCode(BuildContext contenxt) async {
    var resp = await net.request(Routers.USE_EXCHANGE_CODE,
        args: {'exchangeCode': controller.text});
    final flag = resp != null && resp.code == Code.SUCCESS;
    showToast(flag ? Lang.DUIHUANCHENGGONG : Lang.DUIHUANSHIBAI,
        type: flag ? ToastType.positive : ToastType.negative);
    if (flag) {
      updateUserInfo.fire(null);
      Future.delayed(Duration(milliseconds: 1000), () {
        dismissAllToast();
        Navigator.of(contenxt).pop();
      });
    }
    // bool ok = await showConfirm(viewService.context,
    //     title: Lang.WENXINTISHI,
    //     child: Text(resp != null && resp.code == Code.SUCCESS
    //         ? Lang.DUIHUANCHENGGONG
    //         : Lang.DUIHUANSHIBAI));
    // if (ok && resp.code == 200) {
    //   Navigator.of(viewService.context).pop();
    // }
  }
}
