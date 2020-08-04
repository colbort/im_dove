import 'package:app/config/colors.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:app/widget/custom_nested_scroll_view.dart';
import 'package:app/widget/custom_tab_indicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'cover_widget.dart';

/// 我的
class PaoMineWidget extends StatefulWidget {
  final PaoUserDataModel userData;
  final Dispatch dispatch;
  final ViewService viewService;
  final List<MainPaoItemState> myReleaseList;
  final List<MainPaoItemState> buyOrCollectList;
  final List<PaoCommentModel> commentList;
  final bool bSelf;
  final Function onLoadingFn;
  final Function onRefreshFn;
  final Function onTabChangeFn;

  /// 我的帖子刷新数据
  final RefreshController myPostRefreshController;

  ///  我的评论刷新数据
  final RefreshController myReplysRefreshController;

  /// 我的收藏购买刷新数据
  final RefreshController myFav2BuyrefreshController;
  // final ScrollController buyController;
  // final ScrollController myReleaseController;
  // final ScrollController conmentController;

  const PaoMineWidget({
    this.userData,
    this.dispatch,
    this.viewService,
    this.buyOrCollectList,
    this.myReleaseList,
    this.commentList,
    this.bSelf = true,
    this.onLoadingFn,
    this.onRefreshFn,
    this.onTabChangeFn,
    this.myPostRefreshController,
    this.myReplysRefreshController,
    this.myFav2BuyrefreshController,
    // this.buyController,
    // this.myReleaseController,
    // this.conmentController,
  });

  @override
  PaoMineWidgetState createState() => PaoMineWidgetState();
}

class PaoMineWidgetState extends State<PaoMineWidget>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  ScrollController controller = ScrollController();
  // PageController mPageController = PageController(initialPage: 0);
  var isPageCanChanged = true;

  var tabList = [Lang.COMMENT_HUIFU, Lang.SHOUCANG_YIGOU];

  TabBar getTabbar() {
    var arr = [widget.bSelf ? Lang.WODETIEZI : Lang.TADETIEZI, ...tabList];
    return TabBar(
      controller: tabController,
      indicator: CustomBoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: c.cFFE300,
        tmpHeigth: 18,
        tempTop: 10,
      ),
      tabs: arr.map((f) {
        return Container(
          margin: EdgeInsets.all(0),
          // color: Colors.green,
          alignment: Alignment.center,
          width: f.length * 16.0,
          child: Text(f),
          // padding: EdgeInsets.only(right: 12),
        );
      }).toList(),
      labelColor: Colors.black,
      labelStyle: TextStyle(fontSize: 13),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontSize: 13),
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      labelPadding: EdgeInsets.all(6),
      indicatorPadding: EdgeInsets.only(right: 12),
    );
  }

  Widget getCoverWidget() {
    return CoverWidget(
      userData: widget.userData,
      dispatch: widget.dispatch,
      viewService: widget.viewService,
      bSelf: widget.bSelf,
    );
  }

  SliverAppBar getAppBar() {
    return SliverAppBar(
      leading: Container(),
      // primary: false,
      expandedHeight: Dimens.pt190,
      // floating: true,
      // pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: getCoverWidget(),
      ),
    );
  }

  getTabDataList() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
      alignment: Alignment.centerLeft,
      child: getTabbar(),
    );
  }

  SliverPersistentHeader getTabList() {
    return SliverPersistentHeader(
      delegate: SliverTabBarDelegate(
        getTabDataList(),
        color: Colors.white,
      ),
      pinned: true,
    );
  }

  /// 获取刷新组件
  Widget getpullRefresh(
      Widget child, RefreshController refreshController, int len) {
    return pullRefresh(
      // enablePullDown: false,
      enablePullUp: len > 0,
      refreshController: refreshController,
      onLoading: () {
        if (widget.onLoadingFn != null) {
          widget.onLoadingFn(tabController.index);
        }
      },
      onRefresh: () {
        if (widget.onRefreshFn != null) {
          widget.onRefreshFn(tabController.index);
        }
      },
      child: CustomScrollView(
        // physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      ),
    );
  }

  var pageList = [];
  List<Widget> getPageList() {
    if (pageList.length > 0) return pageList;
    pageList = <Widget>[
      TabViewItem(
        Key("0"),
        getpullRefresh(
          widget.viewService.buildComponent(componentList),
          widget.myPostRefreshController,
          widget.myReleaseList.length,
        ),
      ),
      TabViewItem(
        Key("1"),
        getpullRefresh(
          widget.viewService.buildComponent(mainPaoCommentList),
          widget.myReplysRefreshController,
          widget.commentList.length,
        ),
      ),
      TabViewItem(
        Key("2"),
        getpullRefresh(
          widget.viewService.buildComponent(componentList + "_buy"),
          widget.myFav2BuyrefreshController,
          widget.buyOrCollectList.length,
        ),
      ),
    ];
    return pageList;
  }

  // Widget getPageView() {
  //   return PageView(
  //     physics: ClampingScrollPhysics(),
  //     children: <Widget>[...getPageList()],
  //     onPageChanged: (index) {
  //       if (isPageCanChanged) {
  //         //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
  //         onPageChange(index);
  //       }
  //     },
  //   );
  // }

  TabBarView getTabbarView() {
    return TabBarView(
      controller: tabController,
      children: getPageList(),
    );
  }

  // onPageChange(int index, {PageController p, TabController t}) async {
  //   if (p != null) {
  //     //判断是哪一个切换
  //     isPageCanChanged = false;
  //     await mPageController.animateToPage(index,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
  //     isPageCanChanged = true;
  //   } else {
  //     tabController.animateTo(index); //切换Tabbar
  //   }
  // }

  int temp = 1000;
  @override
  void initState() {
    super.initState();
    if (tabController == null) {
      tabController = TabController(length: 3, initialIndex: 0, vsync: this);
      tabController.addListener(() {
        //TabBar的监听
        if (tabController.index != tabController.animation.value) return;
        if (widget.onTabChangeFn != null)
          widget.onTabChangeFn(tabController.index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var uiWidget = widget.userData == null
        ? Container(
            child: showLoadingWidget(true),
          )
        : Container(
            color: Colors.white,
            child: CustomNestedScrollView(
              headerSliverBuilder: (BuildContext context, bool index) {
                return [
                  getAppBar(),
                  getTabList(),
                ];
              },
              innerScrollPositionKeyBuilder: () {
                var key = tabController.index.toString();
                return Key(key);
              },
              pinnedHeaderSliverHeightBuilder: () {
                return 44;
              },
              body: getTabbarView(),
            ),
          );

    return uiWidget;
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final Color color;
  const SliverTabBarDelegate(this.widget, {this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    context = context;
    return new Container(
      child: widget,
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;
}
