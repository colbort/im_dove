import 'package:app/lang/lang.dart';
import 'package:app/page/fan_and_attention_page/effect.dart';
import 'package:app/page/fan_and_attention_page/widgets/rowItem.dart';
import 'package:app/page/fan_and_attention_page/widgets/tabBarItem.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/BasePage.dart';
import 'package:app/widget/common/defaultWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/custom_tab_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

final tabList = [
  {'title': "粉丝", 'tabId': 0},
  {'title': "关注", 'tabId': 1}
];

Widget buildView(
    FanAndAttentionState state, Dispatch dispatch, ViewService viewService) {
  return FanAndAttentionPage(state, dispatch, viewService);
}

class FanAndAttentionPage extends BasePage with BasicPage {
  final FanAndAttentionState state;
  final Dispatch dispatch;
  final ViewService viewService;
  FanAndAttentionPage(this.state, this.dispatch, this.viewService, {Key key})
      : super(key: key);
  String screenName() => state.screenType == 0 ? '粉丝' : '关注';

  Future _onRefresh() async {
    vibrate();
    if (state.screenType == 0) {
      dispatch(FanAndAttentionActionCreator.getFanList(fetchFansData));
    } else {
      dispatch(
          FanAndAttentionActionCreator.getAttentionList(fetchAttentionData));
    }
  }

  Future _onLoading() async {
    vibrate();
    if (state.screenType == 0) {
      fetchFansData['pageSize'] += 10;
      dispatch(FanAndAttentionActionCreator.getFanList(fetchFansData));
    } else {
      fetchAttentionData['pageSize'] += 10;
      dispatch(
          FanAndAttentionActionCreator.getAttentionList(fetchAttentionData));
    }
  }

  @override
  Widget body() {
    final _renderTabList = tabList.map((f) => {
          ...f,
          'dataNum': f['tabId'] == 0
              ? state.fanList.length
              : state.attentionList.length
        });
    final _renderList =
        state.screenType == 0 ? state.fanList : state.attentionList;
    final _fetchData =
        state.screenType == 0 ? fetchFansData : fetchAttentionData;
    if (_fetchData['pageSize'] > _renderList.length) {
      state.refreshController?.loadNoData();
    } else {
      state.refreshController?.resetNoData();
    }
    final _list = [state.fanList, state.attentionList];
    final tabbar = TabBar(
      indicator: const CustomBoxDecoration(
        color: const Color.fromRGBO(255, 211, 89, 1),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        tmpHeigth: 4,
        tempTop: 35,
      ),
      controller: state.controller,
      tabs: _renderTabList
          .map((e) => tabBarItem(e['title'], portfolioNum: e['dataNum'] ?? 0))
          .toList(),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 50),
      labelColor: Colors.black, //Color.fromRGBO(241, 147, 89, 1),
      labelStyle: const TextStyle(fontSize: 15),
      labelPadding: const EdgeInsets.symmetric(horizontal: 60),
    );
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xff979797), width: 0.5))),
          child: tabbar,
        ),
        state.controller != null
            ? Expanded(
                child: TabBarView(controller: state.controller, children: [
                  ...tabList.map((l) {
                    return _list[l['tabId']].length == 0
                        ? Center(
                            child: state.isInit == true
                                ? new CupertinoActivityIndicator()
                                : showDefaultWidget(DefaultType.noData),
                          )
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(
                              complete: const Text(
                                Lang.SHUAXINWANCHENG,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            footer: ClassicFooter(
                                loadingText: Lang.JIAZAIZHONG,
                                canLoadingText: Lang.SONGKAIJIAZAIGENGDUO,
                                noDataText: Lang.MEIYOUGENGDUOSHUJU,
                                idleText: Lang.SHANGLAJIAZAIGENGDUO,
                                textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal)),
                            controller: state.refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView(
                              addAutomaticKeepAlives: false,
                              children: <Widget>[
                                ..._list[l['tabId']]
                                    .map((f) => rowItem(f, state, viewService)),
                              ],
                            ),
                          );
                  }).toList()
                ]),
              )
            : Container()
      ],
    );
  }
}
