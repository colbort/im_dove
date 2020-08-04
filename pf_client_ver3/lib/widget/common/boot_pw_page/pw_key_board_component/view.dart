import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';
import 'pw_key_view.dart';

Widget buildView(
    PwKeyBoardState state, Dispatch dispatch, ViewService viewService) {
  int cloumnNum = (state.sNumList.length / 3).ceil();

  List<Widget> cloumnList = [];
  for (int i = 0; i < cloumnNum; i++) {
    List<Widget> rowList = [];
    for (int j = 0; j < 3; j++) {
      if (i * 3 + j < state.sNumList.length) {
        rowList.add(PwKeyWight(
          sNum: state.sNumList[i * 3 + j],
          sChar: state.sCharList[i * 3 + j],
          onPressCb: (sValue) {
            dispatch(PwKeyBoardActionCreator.onKeyTypedAction(sValue));
          },
        ));
      }
    }

    cloumnList.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: rowList));
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: cloumnList,
  );
}
