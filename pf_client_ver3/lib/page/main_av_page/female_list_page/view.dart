import 'package:app/page/main_av_page/female_list_page/components/famale_all_list.dart';
import 'package:app/page/main_av_page/female_list_page/components/newest.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'base_tab/custom_tab_view.dart';
import 'state.dart';

Widget buildView(
    FemaleListPageState state, Dispatch dispatch, ViewService viewService) {
  return _FemaleListPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

final Map<String, dynamic> _fetchData = {
  'sortBy': 1,
  'pageSize': 24,
  'ids': []
};

class _FemaleListPageView extends StatelessWidget {
  final FemaleListPageState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _FemaleListPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);

  final List<String> _tabsList = ['最新', '最热', '全部'];

  void _tabHandle(int params) {
    _fetchData['sortBy'] = params + 1;
    dispatch(FemaleListPageActionCreator.changeListType(params));
  }

  @override
  Widget build(BuildContext context) {
    final tabViewList = [
      NewestVideo(types: 1),
      NewestVideo(types: 2),
      FamaleAllList(state: state, dispatch: dispatch)
    ];
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5),
            child: CustomTabView(
              onPositionChange: (int i) {
                _tabHandle(i);
              },
              key: state.tabkey,
              itemCount: _tabsList.length,
              tabBuilder: (context, index) => Container(
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 20,
                  child: Text(_tabsList[index], style: TextStyle(fontSize: 14)),
                ),
              ),
              pageBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: tabViewList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
