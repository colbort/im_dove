import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/widget/main_pao_mine_page/widget/pao_mine_widget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPaoOtherState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      // leading: IconButton(
      //   icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
      //   onPressed: () => Navigator.of(viewService.context).pop(),
      // ),
      title: Text(
        Lang.val(Lang.XX_HOMEPAGE, args: [state.name]),
        style: TextStyle(color: Colors.black),
      ),
    ),
    body: PaoMineWidget(
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
          dispatch(MainPaoOtherActionCreator.onMyPostRefresh());
        } else if (index == 1) {
          dispatch(MainPaoOtherActionCreator.onMyRePlysRefresh());
        } else if (index == 2) {
          dispatch(MainPaoOtherActionCreator.onMyFav2BuyRefresh());
        }
      },
      onLoadingFn: (index) {
        if (index == 0) {
          dispatch(MainPaoOtherActionCreator.onMyPostLoadMore());
        } else if (index == 1) {
          dispatch(MainPaoOtherActionCreator.onMyRePlysLoadMore());
        } else if (index == 2) {
          dispatch(MainPaoOtherActionCreator.onMyFav2BuyLoadMore());
        }
      },
      onTabChangeFn: (index) {
        if (index == 0) {
          if (state.myPostRefreshController.isRefresh)
            state.myPostRefreshController.refreshCompleted();
          if (state.myPostRefreshController.isLoading)
            state.myPostRefreshController.loadComplete();
          if (state.myReleaseList.length == 0) {
            dispatch(MainPaoOtherActionCreator.onMyPostRefresh());
          }
        } else if (index == 1) {
          if (state.myReplysRefreshController.isRefresh)
            state.myReplysRefreshController.refreshCompleted();
          if (state.myReplysRefreshController.isLoading)
            state.myReplysRefreshController.loadComplete();
          if (state.commentList.length == 0) {
            dispatch(MainPaoOtherActionCreator.onMyRePlysRefresh());
          }
        } else if (index == 2) {
          if (state.myFav2BuyrefreshController.isRefresh)
            state.myFav2BuyrefreshController.refreshCompleted();
          if (state.myFav2BuyrefreshController.isLoading)
            state.myFav2BuyrefreshController.loadComplete();
          if (state.buyOrCollectList.length <= 0) {
            dispatch(MainPaoOtherActionCreator.onMyFav2BuyRefresh());
          }
        }
      },
    ),
  );
}
