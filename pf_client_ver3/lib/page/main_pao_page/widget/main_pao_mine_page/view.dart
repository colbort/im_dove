import 'package:app/page/main_pao_page/widget/main_pao_mine_page/widget/pao_mine_widget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPaoMineState state, Dispatch dispatch, ViewService viewService) {
  return PaoMineWidget(
    userData: state.paoUserData,
    myReleaseList: state.myReleaseList,
    buyOrCollectList: state.buyOrCollectList,
    commentList: state.commentList,
    dispatch: dispatch,
    viewService: viewService,
    myPostRefreshController: state.myPostRefreshController,
    myReplysRefreshController: state.myReplysRefreshController,
    myFav2BuyrefreshController: state.myFav2BuyrefreshController,
    onRefreshFn: (index) {
      if (index == 0) {
        dispatch(MainPaoMineActionCreator.onMyPostRefresh());
      } else if (index == 1) {
        dispatch(MainPaoMineActionCreator.onMyRePlysRefresh());
      } else if (index == 2) {
        dispatch(MainPaoMineActionCreator.onMyFav2BuyRefresh());
      }
    },
    onLoadingFn: (index) {
      if (index == 0) {
        dispatch(MainPaoMineActionCreator.onMyPostLoadMore());
      } else if (index == 1) {
        dispatch(MainPaoMineActionCreator.onMyRePlysLoadMore());
      } else if (index == 2) {
        dispatch(MainPaoMineActionCreator.onMyFav2BuyLoadMore());
      }
    },
    onTabChangeFn: (index) {
      if (index == 0) {
        if (state.myPostRefreshController.isRefresh)
          state.myPostRefreshController.refreshCompleted();
        if (state.myPostRefreshController.isLoading)
          state.myPostRefreshController.loadComplete();
        if (state.myReleaseList.length == 0) {
          dispatch(MainPaoMineActionCreator.onMyPostRefresh());
        }
      } else if (index == 1) {
        if (state.myReplysRefreshController.isRefresh)
          state.myReplysRefreshController.refreshCompleted();
        if (state.myReplysRefreshController.isLoading)
          state.myReplysRefreshController.loadComplete();
        if (state.commentList.length == 0) {
          dispatch(MainPaoMineActionCreator.onMyRePlysRefresh());
        }
      } else if (index == 2) {
        if (state.myFav2BuyrefreshController.isRefresh)
          state.myFav2BuyrefreshController.refreshCompleted();
        if (state.myFav2BuyrefreshController.isLoading)
          state.myFav2BuyrefreshController.loadComplete();
        if (state.buyOrCollectList.length <= 0) {
          dispatch(MainPaoMineActionCreator.onMyFav2BuyRefresh());
        }
      }
    },
    // buyController: state.buyController,
    // myReleaseController: state.myReleaseController,
  );
}
