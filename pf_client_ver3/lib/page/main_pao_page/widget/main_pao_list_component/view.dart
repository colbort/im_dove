import 'package:app/widget/common/commWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'state.dart';

Widget buildView(
    MainPaoListState state, Dispatch dispatch, ViewService viewService) {
  var adapte = viewService.buildAdapter();
  return state.dataList.length == 0
      ? Container(
          child: showLoadingWidget(state.inited),
        )
      : MainPaoPageWidget(
          adapte: adapte,
          dispatch: dispatch,
          viewService: viewService,
          refreshController: state.refreshController,
          // scrollController: state.controller,
        );
}

/// 泡吧page
class MainPaoPageWidget extends StatefulWidget {
  final ListAdapter adapte;
  final Dispatch dispatch;
  final ViewService viewService;
  final RefreshController refreshController;
  final ScrollController scrollController;
  const MainPaoPageWidget({
    this.adapte,
    this.dispatch,
    this.viewService,
    this.refreshController,
    this.scrollController,
  });

  @override
  MainPaoPageWidgetState createState() => MainPaoPageWidgetState();
}

class MainPaoPageWidgetState extends State<MainPaoPageWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return widget.adapte.itemBuilder(context, index);
      },
      itemCount: widget.adapte.itemCount,
    );
  }
}
