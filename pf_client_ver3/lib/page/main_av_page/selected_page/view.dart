import 'package:app/page/main_av_page/carousel.dart';
import 'package:app/page/main_av_page/widgets/video_group.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
  SelectedState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  /// 轮播图固定在最上边
  return CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Carousel(
          datas: state.carouses,
          context: viewService.context,
          onClicked: (data) => dispatch(
            SelectedActionCreator.onLaunchUrl(data),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Divider(
          height: 20,
          thickness: 1,
          color: Colors.black12,
        ),
      ),
      state.groups.group.length > 0
          ? SliverList(
              delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                var controllrt = new NextController();
                state.controllers[state.groups?.group[index]?.topicId] =
                    controllrt;
                return VideoGroup(
                  data: state.groups?.group[index],
                  controller: controllrt,
                  onNext: (data) =>
                      dispatch(SelectedActionCreator.onNext(data)),
                );
              }, childCount: state.groups?.group?.length ?? 0),
            )
          : SliverToBoxAdapter(
              child: Center(
              child: CupertinoActivityIndicator(),
            )),
    ],
  );
}
