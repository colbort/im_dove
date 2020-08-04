import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/page/main_av_page/Mine_page/page.dart';
import 'package:app/page/main_av_page/calssify_page/page.dart';
import 'package:app/page/main_av_page/gold_coin_page/page.dart';
import 'package:app/page/main_av_page/selected_page/page.dart';
import 'package:app/umplus/umplus.dart' as umplus;
import 'package:app/utils/dimens.dart';
import 'package:app/widget/custom_tab_indicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../lang/lang.dart';
import 'female_list_page/page.dart';
import 'state.dart';

Widget buildView(
  MainAvState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  var buttons = [
    Lang.AV_CLASSIFY,
    Lang.AV_SELECTED,
    Lang.AV_GOLD_COIN_AREA,
    Lang.AV_ACTRESS,
    Lang.AV_WODE,
  ];

  var pages = [
    CalssifyPage().buildPage({
      "controller": state.controller,
    }),
    SelectedPage().buildPage(null),
    GoldCoinPage().buildPage(null),
    FemaleListPage().buildPage(null),
    MinePage().buildPage(null),
  ];

  return Scaffold(
    body: SafeArea(
      child: CustomWidget(
        buttons: buttons,
        pages: pages,
        initialIndex: 1,
        onChangedIndex: (index) {},
      ),
    ),
  );
}

class CustomWidget extends StatefulWidget {
  CustomWidget({
    this.buttons,
    this.pages,
    this.initialIndex,
    this.onChangedIndex,
  });
  final List<String> buttons;
  final List<Widget> pages;
  final int initialIndex;
  final ValueChanged<int> onChangedIndex;
  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: widget.buttons.length,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      widget.onChangedIndex(_tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: Dimens.ptRealW - Dimens.pt40,
              child: TabBar(
                controller: _tabController,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 6),
                tabs: widget.buttons
                    .map((title) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Tab(text: title),
                        ))
                    .toList(),
              ),
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.topRight,
                width: Dimens.pt40,
                height: Dimens.pt30,
                child: SvgPicture.asset(
                  ImgCfg.COMMON_SEARCH,
                  width: Dimens.pt30,
                  height: Dimens.pt30,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                umplus
                    .event(umplus.Events.pvavvsousuo,
                        needRecordOperation: false)
                    .sendEvent();
                Navigator.of(context)
                    .pushNamed('search', arguments: {"type": 1});
              },
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
            controller: _tabController,
            children: widget.pages,
          ),
        ),
      ],
    );
  }
}
