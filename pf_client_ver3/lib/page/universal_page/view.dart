import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';

import '../../widget/common/BasePage.dart';

import 'state.dart';

Widget buildView(
    UniversalPageState state, Dispatch dispatch, ViewService viewService) {
  return _UniversalView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _UniversalView extends BasePage with BasicPage {
  final UniversalPageState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _UniversalView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => Lang.QUANMINGDAILI;
  String rightText() => Lang.QUANMINGDAILI;
  List<Widget> actions() => _getRightButton();

  @override
  Widget body() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 144,
          decoration: BoxDecoration(
            color: Color(0xffffe150),
            borderRadius: BorderRadius.circular((8.0)),
          ),
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: _bulidColumn1(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(21, 30, 15, 0),
          child: _text(Lang.DANGSHUJUTONGJI, Colors.black, 16, FontWeight.w600),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
          child: _bulidColumn3(),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
          child: _bulidColumn4(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(21, 30, 15, 0),
          child:
              _text(Lang.TUIGAUNGZONGSHUJU, Colors.black, 16, FontWeight.w600),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
          child: _bulidColumn6(),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
          child: _bulidColumn7(),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(viewService.context).pushNamed('Promotionpage');
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: double.infinity,
              child: Container(
                alignment: Alignment.center,
                color: Color(0xffffe150),
                width: double.infinity,
                height: 50,
                child:
                    _text(Lang.QUTUIGUANG, Colors.black, 16, FontWeight.w600),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _text(
      String text, Color color, double textSize, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style:
          TextStyle(fontSize: textSize, fontWeight: fontWeight, color: color),
    );
  }

  _bulidColumn1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _text(Lang.ZONGYEJI, Colors.black, 18, FontWeight.w500)),
            Expanded(
                child:
                    _text(Lang.ZONGSHOUYI, Colors.black, 18, FontWeight.w500)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _text(state.income, Colors.black, 36, FontWeight.w600)),
            Expanded(
                child:
                    _text(state.brokerage, Colors.black, 36, FontWeight.w600)),
          ],
        )
      ],
    );
  }

  _bulidColumn3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _text(
                    state.brokerageDay, Colors.black, 18, FontWeight.w500)),
            Expanded(
                child:
                    _text(state.incomeDay, Colors.black, 18, FontWeight.w500)),
            Expanded(
                child: _text(
                    state.promotionDay, Colors.black, 18, FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  _bulidColumn4() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _text(
                    Lang.DANGRISHOUYI, Color(0xff222222), 12, FontWeight.w300)),
            Expanded(
                child: _text(
                    Lang.DANGRIYEJI, Color(0xff222222), 12, FontWeight.w300)),
            Expanded(
                child: _text(Lang.DANGRITUIGUANGRENSHU, Color(0xff222222), 12,
                    FontWeight.w300)),
          ],
        )
      ],
    );
  }

  _bulidColumn6() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child:
                    _text(state.brokerage, Colors.black, 18, FontWeight.w500)),
            Expanded(
                child: _text(state.income, Colors.black, 18, FontWeight.w500)),
            Expanded(
                child:
                    _text(state.promotion, Colors.black, 18, FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  _bulidColumn7() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: _text(Lang.ZONGSHOUYI + " (元)", Color(0xff222222), 12,
                    FontWeight.w300)),
            Expanded(
                child: _text(Lang.ZONGYEJI + " (元)", Color(0xff222222), 12,
                    FontWeight.w300)),
            Expanded(
                child: _text(Lang.ZONGTUIGUANGRENSHU, Color(0xff222222), 12,
                    FontWeight.w300)),
          ],
        )
      ],
    );
  }

  _getRightButton() {
    return [
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
        height: double.infinity,
        alignment: Alignment.center,
        child: GestureDetector(
          child: _text(Lang.GUIZHE, Color(0xff363636), 16, FontWeight.w400),
          onTap: () {
            //右侧的点击事件
            Navigator.of(viewService.context).pushNamed('RulerPage');
          },
        ),
      )
    ];
  }
}
