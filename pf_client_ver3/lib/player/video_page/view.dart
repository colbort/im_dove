import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/widget/common/commWidget.dart' as commWidget;

Widget buildView(VideoState state, Dispatch dispatch, ViewService viewService) {
  return SafeArea(
    top: true,
    child: AppWidget(
      state: state,
      dispatch: dispatch,
      viewService: viewService,
    ),
  );
}

class AppWidget extends StatelessWidget {
  const AppWidget({
    Key key,
    this.state,
    this.dispatch,
    this.viewService,
  });

  final VideoState state;
  final Dispatch dispatch;
  final ViewService viewService;

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    //竖屏
    if (_height > _width) {
      Future.delayed(Duration(seconds: 1), () {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(Colors.black12);
      });

      return Material(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                viewService.buildComponent("VideoComComponent"),
                viewService.buildComponent("VideoInfoComponent"),
              ],
            ),
            Align(
                child: state.bShowDiaog ? getDialog(state.reason) : Container())
          ],
        ),
      );
    } else {
      //横屏之后要重置动画参数，以免切换到竖屏后，动画再次播放
      state.infoState.snapToEnd = true;
      return Material(
        child: Column(
          children: <Widget>[
            viewService.buildComponent("VideoComComponent"),
          ],
        ),
      );
    }
  }

  Widget getDialog(int reason) {
    if (!state.bShowDiaog) return Container();
    if (reason == 1)
      return commWidget.noTimesDialog(viewService.context, () {
        // dispatch(VideoActionCreator.closeVideoDialogAction());
      }, () {
        dispatch(VideoActionCreator.closeVideoDialogAction());
      });
    if (reason == 2)
      return commWidget.buyVipDialog(viewService.context, () {
        // dispatch(VideoActionCreator.closeVideoDialogAction());
      }, () {
        dispatch(VideoActionCreator.closeVideoDialogAction());
      });
    if (reason == 3) {
      /// 余额购买
      if (checkWalletEnough(state.wallet, state.price)) {
        return commWidget.buyDialog(viewService.context, state.price, 1, () {
          dispatch(VideoActionCreator.onBuyVideo(state.videoId));
        }, () {
          dispatch(VideoActionCreator.closeVideoDialogAction());
        });
      } else {
        // 去充值 钱包界面
        return commWidget.buyDialog(viewService.context, state.price, 2, () {
          Navigator.of(viewService.context).pushNamed("WalletPage");
        }, () {
          dispatch(VideoActionCreator.closeVideoDialogAction());
        });
      }
    }
    return Container();
  }

  checkWalletEnough(double number, String price) {
    if (price == null && price.isEmpty) return false;
    return number >= double.parse(price);
  }
}
