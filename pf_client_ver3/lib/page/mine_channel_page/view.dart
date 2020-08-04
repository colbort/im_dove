import 'package:app/lang/lang.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../widget/common/BasePage.dart';
import 'state.dart';

Widget buildView(
    MineChannelState state, Dispatch dispatch, ViewService viewService) {
  return _SetPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _SetPageView extends BasePage with BasicPage {
  final MineChannelState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _SetPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => Lang.TUIGUANG;

  @override
  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
  }
}
