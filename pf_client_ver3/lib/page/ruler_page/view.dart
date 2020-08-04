import 'package:app/lang/lang.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/common/BasePage.dart';
import 'state.dart';

Widget buildView(RulerState state, Dispatch dispatch, ViewService viewService) {
  return _RulerView(dispatch: dispatch, state: state, viewService: viewService);
}

class _RulerView extends BasePage with BasicPage {
  final Dispatch dispatch;
  final ViewService viewService;
  final RulerState state;

  _RulerView({Key key, this.dispatch, this.viewService, this.state})
      : super(key: key);

  @override
  String screenName() => Lang.DAILIGUIZHE;

  @override
  Widget body() {
    return Container(
      child: ListView(
        children: <Widget>[
          Image.asset(
            'assets/mine/rules.jpg',
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(viewService.context).size.width,
          ),
        ],
      ),
    );
  }
}
