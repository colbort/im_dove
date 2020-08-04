import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/custom_tab_indicator.dart';
import 'package:app/widget/keep_alive_widget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'action.dart';
import 'state.dart';
import 'widget/main_pao_mine_page/page.dart';
import 'widget/main_pao_view_page/page.dart';

Widget buildView(
    MainPaoState state, Dispatch dispatch, ViewService viewService) {
  return MainPaoPage(
    state: state,
    dispatch: dispatch,
    viewService: viewService,
  );
}

/// 泡吧item
class MainPaoPage extends StatefulWidget {
  final MainPaoState state;
  final Dispatch dispatch;
  final ViewService viewService;
  const MainPaoPage({this.state, this.dispatch, this.viewService});

  @override
  MainPaoPageState createState() => MainPaoPageState();
}

class MainPaoPageState extends State<MainPaoPage>
    with SingleTickerProviderStateMixin {
  Dispatch dispatch;
  ViewService viewService;
  ListAdapter adapte;

  /// tabbar
  Widget getTabBar() {
    return TabBar(
      controller: tabController,
      indicator: CustomBoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: c.cFFE300,
        tmpHeigth: 12,
        tempTop: 20,
      ),
      tabs: tabList.map((f) {
        return Container(
          margin: EdgeInsets.all(0),
          // color: Colors.green,
          alignment: Alignment.center,
          width: f.name.length * 20.0,
          child: Text(f.name),
          // padding: EdgeInsets.only(right: 12),
        );
      }).toList(),
      labelColor: Colors.black,
      labelStyle: TextStyle(fontSize: 18),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontSize: 16),
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      labelPadding: EdgeInsets.all(6),
      indicatorPadding: EdgeInsets.only(right: 12),
    );
  }

// MainPaoPageWidget(
//             adapte: adapte,
//             dispatch: dispatch,
//             viewService: viewService,
//           ),
  /// tabbarview
  Widget getTabbarView() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        KeepAliveWidget(MainPaoViewPage().buildPage({"stype": 0})),
        KeepAliveWidget(MainPaoViewPage().buildPage({"stype": 1})),
        KeepAliveWidget(MainPaoViewPage().buildPage({"stype": 2})),
        KeepAliveWidget(MainPaoViewPage().buildPage({"stype": 3})),
        MainPaoMinePage().buildPage(null),
      ],
    );
  }

  Widget getSearchWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        // width: Dimens.pt50,
        child: SvgPicture.asset(ImgCfg.COMMON_SEARCH),
      ),
      onTap: () {
        /// 点击搜索
        // Navigator.of(viewService.context).pushNamed(page_s);
        print('搜索');
        Navigator.of(context).pushNamed('search', arguments: {"type": 2});
      },
    );
  }

  Widget getFloatWidget() {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(widget.viewService.context)
              .pushNamed(page_uploadVedioPage);
        },
        child: Container(
          width: Dimens.pt62,
          height: Dimens.pt62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: c.cFFE300,
          ),
          child: Icon(
            Icons.add,
            size: 60,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (tabController == null)
      tabController =
          TabController(initialIndex: 1, length: tabList.length, vsync: this);
    tabController.addListener(() {
      if (tabController.index.toDouble() != tabController.animation.value)
        return;

      // widget.dispatch(MainPaoActionCreator.changeType(tabController.index));
      widget.dispatch(MainPaoActionCreator.onInitData(tabController.index));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // pinned: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getTabBar(),
                getSearchWidget(context),
              ],
            ),
          ),
        ),
      ),
      body: getTabbarView(),
      floatingActionButton: getFloatWidget(),
    );
  }
}
