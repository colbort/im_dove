import 'package:app/page/main_av_page/widgets/vedio_item.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PurchaseState state, Dispatch dispatch, ViewService viewService) {
  return pullRefresh(
    enablePullDown: true,
    refreshController: state.refreshcontroller,
    onRefresh: () => dispatch(PurchaseActionCreator.onRefresh()),
    onLoading: () => dispatch(PurchaseActionCreator.onLoadMore()),
    child: (state.datas?.length ?? 0) <= 0
        ? Container(
            margin: EdgeInsets.only(top: Dimens.pt100),
            alignment: Alignment.center,
            child: showLoadingWidget(false))
        : GridView.builder(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
            itemCount: state.datas?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 1.19,
            ),
            itemBuilder: (context, index) {
              return VideoPreview(
                width: state.itemW,
                height: state.itemH,
                timeVisible: true,
                data: state.datas[index].video,
              );
            },
          ),
  );
}
