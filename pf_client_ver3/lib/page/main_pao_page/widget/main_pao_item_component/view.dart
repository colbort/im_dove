import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../main_pao_item.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPaoItemState state, Dispatch dispatch, ViewService viewService) {
  return MainPaoItemWidget(
    data: state.paoDataModel,
    dispatch: dispatch,
    viewService: viewService,
    bShowUserData: state.bShowUserData,
    onOptCallbackFn: () {
      if (state.paoDataModel?.isBuy == true) return;
      dispatch(MainPaoItemActionCreator.onBuyPost(state.paoDataModel.no));
    },
  );
}
