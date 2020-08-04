import 'package:app/config/colors.dart';
import 'package:app/page/main_av_page/widgets/vedio_item.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
  GoldCoinState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  return pullRefresh(
    refreshController: state.controller,
    enablePullDown: false,
    child: ListView.builder(
      itemCount: state.videos?.videos?.length ?? 0,
      itemBuilder: (context, index) {
        return Container(
          height: state.itemH + 52,
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: VideoPreview(
                  width: state.itemW,
                  height: state.itemH,
                  data: state.videos?.videos[index],
                ),
              ),
              Divider(
                color: c.cFFF0F0F0,
                height: 10,
                thickness: 2,
              ),
            ],
          ),
        );
      },
    ),
    onLoading: () {
      dispatch(GoldCoinActionCreator.onLoading());
    },
    onRefresh: () {
      dispatch(GoldCoinActionCreator.onRefresh());
    },
  );
}
