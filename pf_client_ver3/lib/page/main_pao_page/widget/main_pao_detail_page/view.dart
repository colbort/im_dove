import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/comment_page/custom_comment_short.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPaoDetailState state, Dispatch dispatch, ViewService viewService) {
  ///底部评论提示框
  Widget _footerComment() {
    return GestureDetector(
      onTap: () {
        if (state.commentController.onShowInputFn != null) {
          state.commentController.onShowInputFn();
        }
      },
      child: Container(
        height: Dimens.pt50,
        width: Dimens.pt360,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: Dimens.pt10),
              child: Text(
                Lang.COMMENT_INPUT_TIP,
                style: TextStyle(color: Colors.grey, fontSize: Dimens.pt14),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Dimens.pt10),
              child: SvgPicture.asset(
                ImgCfg.COMMENT_SEND,
                width: Dimens.pt21,
                height: Dimens.pt21,
              ),
            )
          ],
        ),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(Lang.POST_DETAIL),
    ),
    body: pullRefresh(
      refreshController: state.refreshController,
      onLoading: () {
        if (state.commentController.onLoadMoreFn != null) {
          state.commentController.onLoadMoreFn();
        }
      },
      onRefresh: () {
        dispatch(MainPaoDetailActionCreator.onRefresh());
      },
      child: CustomScrollView(
        controller: state.scrollController,
        slivers: <Widget>[
          /// 帖子
          SliverToBoxAdapter(
            child: state.paoDataModel == null
                ? Container(
                    child: showLoadingWidget(false),
                  )
                : MainPaoItemWidget(
                    data: state.paoDataModel,
                    dispatch: dispatch,
                    viewService: viewService,
                    bShowUserData: false,
                  ),
          ),
          SliverToBoxAdapter(
            child: getHengLine(
              h: 4,
              color: c.cD8D8D8,
              margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
              child: Text(
                Lang.PINGLUN,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: state.commentModelList.length == 0
                ? Container(
                    child: showLoadingWidget(false),
                  )
                : CustomCommentShortWidget(
                    commentTotalCount: state.commentModelList.length,
                    objectId: state.postId,
                    commentList: state.commentModelList,
                    commentController: state.commentController,
                    refreshController: state.refreshController,
                    // callback: callback,
                  ),
          ),
        ],
        // controller: state.scrollController,
      ),
    ),
    floatingActionButton: _footerComment(),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}
