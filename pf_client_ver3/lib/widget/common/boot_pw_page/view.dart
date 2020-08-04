import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/services.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    BootPwState state, Dispatch dispatch, ViewService viewService) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  final clientWidth = MediaQuery.of(viewService.context).size.width;

  return !state.isShow
      ? Container()
      : Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              appBar: state.isShowAppBar
                  ? AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Text('${state.appBarTitle}',
                          style: TextStyle(color: Colors.black)),
                      leading: IconButton(
                        icon: Icon(Icons.navigate_before,
                            color: Colors.black, size: 40),
                        onPressed: () =>
                            Navigator.of(viewService.context).pop(),
                      ))
                  : null,
              backgroundColor: Colors.white,
              body: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      top: s.realHByH(80),
                      child: Text(
                        state.inputTitle,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Positioned(
                      top: s.realHByH(150),
                      child: Container(
                        width: 280,
                        height: 70,
                        // decoration: BoxDecoration(color: Colors.blue),
                        child: viewService.buildComponent('pwPoint'),
                        // Stack(
                        //   alignment: Alignment.center,
                        //   children: <Widget>[
                        //     viewService.buildComponent('pwPoint'),
                        // TextField(
                        //   controller: controller,
                        //   keyboardType: TextInputType.numberWithOptions(),
                        //   inputFormatters: [
                        //     LengthLimitingTextInputFormatter(4)
                        //   ],
                        //   style: TextStyle(fontSize: 0),
                        //   decoration: InputDecoration(
                        //       enabledBorder: InputBorder.none,
                        //       disabledBorder: InputBorder.none,
                        //       focusedBorder: InputBorder.none,
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 35)),
                        //   showCursor: false,
                        //   autofocus: true,
                        //   enableInteractiveSelection: false,
                        //   onChanged: (v) {
                        //     print('test onChanged ${v}');
                        //   },
                        // ),
                        //   ],
                        // )
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                          width: clientWidth,
                          height: _customRealW(250, clientWidth),
                          decoration: BoxDecoration(color: Color(0xffeeeeee)),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: _customRealW(9, clientWidth),
                                width: clientWidth,
                                child: Center(
                                  child:
                                      viewService.buildComponent('pwKeyBoard'),
                                ),
                              ),
                              Positioned(
                                bottom: _customRealW(23, clientWidth),
                                right: _customRealW(24, clientWidth),
                                child: FlatButton(
                                  padding: EdgeInsets.zero,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/boot_pw/close_btn.png'),
                                    width: _customRealW(33, clientWidth),
                                    height: _customRealW(18, clientWidth),
                                  ),
                                  onPressed: () {
                                    dispatch(BootPwActionCreator
                                        .onDelTypedPwAction());
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ));
}

_customRealW(double w, double clientWidth) {
  return clientWidth / 360 * w;
}
