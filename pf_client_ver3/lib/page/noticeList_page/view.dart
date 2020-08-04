import 'package:app/lang/lang.dart';
import 'package:app/widget/common/defaultWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/common/pullRefresh.dart';
import '../../widget/common/BasePage.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    NoticeListState state, Dispatch dispatch, ViewService viewService) {
  return _BuildView(dispatch: dispatch, state: state, viewService: viewService);
}

final Map<String, dynamic> _fetchData = {
  'page': 1,
  'pageSize': 20,
};

class _BuildView extends BasePage with BasicPage {
  final NoticeListState state;
  final Dispatch dispatch;
  final ViewService viewService;
  _BuildView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);

  Future _onRefresh() async {
    _fetchData['pageSize'] = 20;
    dispatch(NoticeListActionCreator.getNoticeList(_fetchData));
  }

  Future _onLoading() async {
    _fetchData['pageSize'] += 20;
    dispatch(NoticeListActionCreator.getNoticeList(_fetchData));
  }

  @override
  Widget body() {
    if (_fetchData['pageSize'] > state.list.length) {
      state.refreshController.loadNoData();
    }
    final ListAdapter adapter = viewService.buildAdapter();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 16),
        child: Column(
          children: <Widget>[
            state.list.length <= 0
                ? Expanded(
                    child: Center(
                    child: state.isInit
                        ? new CupertinoActivityIndicator()
                        : showDefaultWidget(DefaultType.noData),
                  ))
                : pullRefresh(
                    child: ListView.builder(
                        itemBuilder: adapter.itemBuilder,
                        itemCount: adapter.itemCount),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    refreshController: state.refreshController)
          ],
        ),
      ),
    );
  }

  @override
  String screenName() => Lang.GONGGAOXIAOXI;
}
