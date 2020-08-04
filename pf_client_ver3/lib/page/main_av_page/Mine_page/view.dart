import 'package:app/config/colors.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_av_page/Mine_page/collections_page/page.dart';
import 'package:app/page/main_av_page/Mine_page/purchase_page/page.dart';
import 'package:app/page/main_av_page/Mine_page/video_record_page/page.dart';
import 'package:app/widget/customTabIndicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(MineState state, Dispatch dispatch, ViewService viewService) {
  var buttons = [
    Lang.AV_COLLECTION,
    Lang.AV_PURCHASE,
    Lang.AV_VIEWING_RECORD,
  ];

  var pages = [
    CollectionsPage().buildPage(null),
    PurchasePage().buildPage(null),
    VideoRecordPage().buildPage(null),
  ];

  return Scaffold(
    body: SafeArea(
      child: DefaultTabController(
        length: buttons.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TabBar(
                labelColor: c.cFF3A3A3A,
                unselectedLabelColor: c.c979797,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 0,
                indicator: CustomBoxDecoration(
                  color: Colors.yellow,
                  tmpHeigth: 10,
                  tempTop: 23,
                  borderRadius: BorderRadius.circular(5),
                ),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 6),
                tabs: buttons
                    .map((title) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Tab(text: title),
                        ))
                    .toList(),
              ),
            ),
            Divider(
              height: 10,
              thickness: 1,
              color: Colors.black12,
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                children: pages,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
