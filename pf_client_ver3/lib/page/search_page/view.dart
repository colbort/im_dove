import 'package:app/lang/lang.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:app/widget/searchBar.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'action.dart';
import 'state.dart';
import 'widgets/TagsBoxItem.dart';

final i6 = 6.0;

Widget buildView(
    SearchMainPageState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SearchBar(dispatch, state.searchController, () {
            //清空搜索栏
            dispatch(MainSearchActionCreator.clearSearchData());
          }, () {
            state.keywords = state.searchController.text;
            if (state.keywords.length != 0) {
              //搜索列表
              dispatch(MainSearchActionCreator.onSearchData(
                  state.keywords)); //_searchController.text
              //搜索博主
              if (state.type == 2)
                dispatch(MainSearchActionCreator.onSearchUserData());
            }
          }),
        ),
      ),
      //type 1 av    type 2 泡吧
      body: state.isSearch
          ? pullRefresh(
              refreshController: state.refreshController,
              onLoading: () {
                dispatch(MainSearchActionCreator.onSearchNextData());
              },
              onRefresh: () {
                dispatch(MainSearchActionCreator.onSearchData(
                    state.searchController.text));
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  viewService.buildComponent(state.type == 1 ? 'av' : 'paoba')
                ],
              ))
          : (state.hotTags.length == 0
              ? Center(child: CupertinoActivityIndicator())
              : Column(
                  children: <Widget>[
                    state.historyTags.length > 0
                        ? TagsBoxItem(
                            dispatch: dispatch,
                            itemTitle: Lang.SEARCH_HIS,
                            showDelIcon: true,
                            tagsBox: state.historyTags,
                            searchController: state.searchController,
                            type: state.type,
                          )
                        : SizedBox.shrink(),
                    TagsBoxItem(
                      dispatch: dispatch,
                      itemTitle: Lang.SEARCH_HOT,
                      tagsBox: state.hotTags,
                      searchController: state.searchController,
                      type: state.type,
                    ),
                  ],
                )));
}
