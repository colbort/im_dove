import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/player/preview_player/preview_player.dart';
import 'package:app/player/preview_player/preview_player_ctrl.dart';
import 'package:app/player/video_element/uninitialized_widget.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';

/// 视频播放
class MainPaoVideo extends StatefulWidget {
  final bool isPlay;

  final PaoDataModel paoDataModel;
  final Function onOptCallbackFn;

  const MainPaoVideo({
    this.isPlay,
    this.paoDataModel,
    this.onOptCallbackFn,
  });

  @override
  MainPaoVideoState createState() => MainPaoVideoState();
}

class MainPaoVideoState extends State<MainPaoVideo> {
  /// 显示弹窗
  var bShowAlert = false;

  ///视频加载中表现形式，后续有需求可以在此修改
  Widget buildUnInitializedWidget(
      double width, double height, TapCallBack tapCallBack) {
    return GestureDetector(
      onTap: () {
        if (tapCallBack != null) {
          tapCallBack(null);
        }
      },
      child: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: buildLoading(),
      ),
    );
  }

  Widget _getVideoCover() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //背景
        Container(
          // color: Colors.black45,
          width: s.screenWidth,
          height: Dimens.pt240,
          child: ImageLoader.withP(
            ImageType.IMAGE_NETWORK_HTTP,
            getImgDomain() + widget.paoDataModel.videoImg,
            width: s.screenWidth,
            height: Dimens.pt240,
            fit: BoxFit.fitWidth,
          ).load(),
        ),
        //中间的播放按钮，只有预览的时候有哦
        TextUtil.isNotEmpty(widget.paoDataModel.videoPreviewUrl) ||
                TextUtil.isNotEmpty(widget.paoDataModel.videoURL)
            ? Center(
                child: ImageLoader.withP(
                        ImageType.IMAGE_SVG, ImgCfg.MAIN_VEDIO_PLAY,
                        width: Dimens.pt50, height: Dimens.pt50)
                    .load(),
              )
            : Container(),
        // Offstage(
        //   offstage: !widget.paoDataModel.isBuy && !bShowAlert,
        //   // child: getVideoBuyWidget(isBought, cost),
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paoDataModel == null)
      return Container(
        width: Dimens.pt328,
        height: Dimens.pt218,
        color: Colors.black,
      );
    var coverWidget = _getVideoCover();
    return GestureDetector(
      onTap: () {
        if (!widget.paoDataModel.isBuy && widget.paoDataModel.price > 0) {
          return;
        }
        Navigator.of(context).pushNamed(page_main_pao_play,
            arguments: {"data": widget.paoDataModel});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.pt8),
        child: Stack(
          children: <Widget>[
            Container(
              width: Dimens.pt328,
              height: Dimens.pt218,
              color: Colors.black,
              child: (widget.isPlay)
                  // child:(isPlay &&
                  //         (videoBean?.id ?? 0) > 0 &&
                  //         TextUtil.isNotEmpty(videoBean.preUrl))
                  ? PreViewVideoElement(
                      controller: getCtrl(widget.paoDataModel.videoPreviewUrl),
                      rotateToFullScreen: false,
                      width: s.screenWidth,
                      height: Dimens.pt240,
                      unInitializedBuilder: buildUnInitializedWidget,
                      isFixWidth: false,
                      disposedWidget: coverWidget,
                    )
                  : coverWidget,
            ),
            getPostTypeWidget(
              isVip: false,
              isbuy: widget.paoDataModel.isBuy,
              price: widget.paoDataModel.price,
              callback: widget.onOptCallbackFn,
              context: context,
            )
          ],
        ),
      ),
    );
  }
}

/// 购买视频
Widget getPostTypeWidget(
    {double w,
    double h,
    bool isVip,
    bool isbuy,
    int price,
    BuildContext context,
    Function callback}) {
  if (w == null) {
    w = Dimens.pt328;
  }
  if (h == null) {
    h = Dimens.pt218;
  }
  if (!isVip && price == 0) {
    return Container();
  }
  if (!isbuy) {
    if (price != null && price > 0) {
      var wallet = getWalletData();
      var bEnough = wallet.balance >= price;
      return GestureDetector(
        onTap: () {
          if (!bEnough) {
            Navigator.of(context).pushNamed(page_walletPage);
            return;
          }
          if (callback != null) {
            callback();
          }
        },
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(color: Colors.black45),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// 提示文本
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimens.pt9),
                  child: Text(
                    Lang.DIALOG_DAYE,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                /// 提示文本
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimens.pt9),
                  child: Text(
                    Lang.val(Lang.VIDEO_TIP_N, args: [price]),
                    style: TextStyle(
                      fontSize: 14,
                      color: c.cFFE300,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                /// 购买按钮
                Container(
                  width: Dimens.pt130,
                  height: Dimens.pt30,
                  decoration: BoxDecoration(
                    color: c.cFFE300,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: EdgeInsets.only(top: Dimens.pt9),
                  alignment: Alignment.center,
                  child: Text(
                    !bEnough ? Lang.QU_CHONGZHI : Lang.LIJI_BUY,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  return Container();
}
