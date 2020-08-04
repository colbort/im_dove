import 'package:app/page/main_av_page/widgets/classify.dart';
import 'package:app/page/main_av_page/widgets/vedio_item.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:app/widget/custom_nested_scroll_view.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    CalssifyState state, Dispatch dispatch, ViewService viewService) {
  return CustomNestedScrollView(
    controller: state.scrollController,
    headerSliverBuilder: (context, defVal) {
      return [
        SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 3 * Dimens.pt44,
            backgroundColor: Colors.white,
            title: AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: 1 - (state.showTitle - 56) / (3 * Dimens.pt44 - 56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.selected?.length ?? 0,
                  (index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.yellow,
                        ),
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Text(
                          state.selected[index]?.name.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (state.showTitle != constraints.biggest.height.toInt()) {
                  dispatch(CalssifyActionCreator.toggleTitle(
                      constraints.biggest.height.toInt()));
                }
                return FlexibleSpaceBar(
                  background: state.selected[0].id != null
                      ? Column(
                          children: <Widget>[
                            ClassifyWidget(
                              classify: state.classify?.sorts,
                              currentId: state.selected[0].id,
                              onClicked: (data) {
                                dispatch(CalssifyActionCreator.changeTag(
                                    {'index': 0, 'data': data}));
                                dispatch(CalssifyActionCreator.onFilter());
                              },
                            ),
                            ClassifyWidget(
                              classify: state.classify?.categorys,
                              currentId: state.selected[1].id,
                              onClicked: (data) {
                                dispatch(CalssifyActionCreator.changeTag(
                                    {'index': 1, 'data': data}));
                                dispatch(CalssifyActionCreator.onFilter());
                              },
                            ),
                            ClassifyWidget(
                              classify: state.classify?.tags,
                              currentId: state.selected[2].id,
                              onClicked: (data) {
                                dispatch(CalssifyActionCreator.changeTag(
                                    {'index': 2, 'data': data}));
                                dispatch(CalssifyActionCreator.onFilter());
                              },
                            ),
                          ],
                        )
                      : Container(),
                );
              },
            )),
      ];
    },
    body: state.videos.videos.length > 0
        ? pullRefresh(
            refreshController: state.refreshController,
            child: GridView.builder(
              // controller: state.controller,
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              itemCount: state.videos?.videos?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (context, index) {
                return VideoPreview(
                  width: state.itemW,
                  height: state.itemH,
                  data: state.videos?.videos[index],
                );
              },
            ),
            onLoading: () => dispatch(CalssifyActionCreator.onLoading()),
            onRefresh: () => dispatch(CalssifyActionCreator.onRefresh()),
          )
        : Center(
            child: CupertinoActivityIndicator(),
          ),
  );
}
