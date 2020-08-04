import 'package:app/config/colors.dart';
import 'package:app/config/text_style.dart';
import 'package:app/pojo/recommend_bean.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/custom_tab_indicator.dart';
import 'package:app/widget/keep_alive_widget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'effect.dart';
import 'simple_recommand_page/page.dart';
import 'state.dart';

Widget buildView(
    RecommendPageState state, Dispatch dispatch, ViewService viewService) {
  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 顶部的三个标题
        Container(
          padding: EdgeInsets.only(left: Dimens.pt8),
          child: TabBar(
            controller: recommendTabController,
            labelColor: c.c333333,
            labelStyle:
                TextStyle(fontSize: t.fontSize18, fontWeight: FontWeight.w500),
            unselectedLabelColor: c.c979797,
            unselectedLabelStyle:
                TextStyle(fontSize: t.fontSize16, fontWeight: FontWeight.w500),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: CustomBoxDecoration(
              color: Colors.yellow,
              tmpHeigth: Dimens.pt10,
              tempTop: Dimens.pt22,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.pt6)),
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: Dimens.pt4),
            tabs: recommandTitles
                .map((title) => Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.pt4),
                      child: Tab(text: title),
                    ))
                .toList(),
          ),
        ),
        // 底部的是那三个子页面
        Expanded(
          flex: 1,
          child: TabBarView(
            controller: recommendTabController,
            children: <Widget>[
              KeepAliveWidget(
                  SimpleRecommandPage().buildPage(RECOMMAND_TYPE_GUANFANG)),
              KeepAliveWidget(
                  SimpleRecommandPage().buildPage(RECOMMAND_TYPE_PAOYOU)),
              KeepAliveWidget(
                  SimpleRecommandPage().buildPage(RECOMMAND_TYPE_BANGDAN)),
            ],
          ),
        ),
      ],
    ),
  );
}
