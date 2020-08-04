import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/config/text_style.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/recommend_page/common/author_names_widget.dart';
import 'package:app/page/recommend_page/common/recommand_index_widget.dart';
import 'package:app/player/preview_player/preview_player.dart';
import 'package:app/player/preview_player/preview_player_ctrl.dart';
import 'package:app/player/video_element/uninitialized_widget.dart';
import 'package:app/player/video_player/custom_video_player.dart';
import 'package:app/pojo/recommend_bean.dart';
import 'package:app/pojo/video_bean.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/preview_manager.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/text_util.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:worker_manager/runnable.dart';
import 'package:worker_manager/worker_manager.dart';
import 'action.dart';
import 'state.dart';

double _startScrollOffset = 0;
double _endScrollOffset = 0;
final double _maxItemHeight = s.realH(360);

Widget buildView(
    SimpleRecommandState state, Dispatch dispatch, ViewService viewService) {
  return NotificationListener(
    onNotification: (notification) {
      if (notification is ScrollStartNotification) {
        var start = notification;
        _startScrollOffset = start.metrics.pixels;
        log.i("开始滚动startScrollOffset:$_startScrollOffset");
      } else if (notification is ScrollEndNotification) {
        var end = notification;
        _endScrollOffset = end.metrics.pixels;
        log.i("停止滚动_endScrollOffset:$_endScrollOffset");

        final task = Task3(
            runnable: Runnable(
          arg1: _startScrollOffset,
          arg2: _endScrollOffset,
          arg3: _maxItemHeight,
          fun3: _computeIndex,
        ));
        Executor().addTask(task: task).listen((resultIndex) {
          l.d("move_notify",
              "滚动停止: index:$resultIndex enable:${previewModule.enable}");
          if (resultIndex >= 0) {
            previewModule.lastPlayIndex = resultIndex;
            previewModule.beginAutoPlayIfNeed();
            // dispatch(SimpleRecommandActionCreator.onAutoPlayUI(resultIndex));
          }
        }).onError((e) {
          l.d("move_notify", "滚动停止: error:$e");
        });
      }
      return true;
    },
    child: pullRefresh(
      enablePullDown: true,
      refreshController: state.refreshcontroller,
      onRefresh: () => dispatch(SimpleRecommandActionCreator.onRefresh()),
      onLoading: () => dispatch(SimpleRecommandActionCreator.onLoadMore()),
      child: (state.datas?.length ?? 0) <= 0
          ? Container(
              margin: EdgeInsets.only(top: Dimens.pt100),
              alignment: Alignment.center,
              child: showLoadingWidget(false))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return genarateChildWidget(
                    ctx, dispatch, state, index, state.datas[index]);
              },
              itemCount: state.datas?.length ?? 0,
              itemExtent: _maxItemHeight,
            ),
    ),
  );
}

/// 计算index的方法
int _computeIndex(
    double _startScrollOffset, double _endScrollOffset, double _maxItemHeight) {
  var scrollRate =
      (_endScrollOffset - _startScrollOffset).abs() / _maxItemHeight;
  if (scrollRate < 0.05) {
    print("滚动停止,滚动距离太小了");
    return -1;
  }

  var endOffsetRate = (_endScrollOffset / _maxItemHeight);

  var modRate = (_endScrollOffset % _maxItemHeight) / _maxItemHeight;

  /// 修正过后的偏移率
  var correctEndOffsetRate = endOffsetRate;
  if (_startScrollOffset < _endScrollOffset) {
    // 向下滑动
    // print("move_notify滚动停止向下,滑动量增加了:$scrollRate");
    if (scrollRate <= 0.2 && modRate >= 0.4 && modRate <= 0.6) {
      // 0.4-0.6
      correctEndOffsetRate = endOffsetRate - scrollRate;
    }
  } else {
    // 向上滑动
    // print("move_notify滚动停止向上,滑动量减少了$scrollRate");
    if (scrollRate <= 0.2 && modRate >= 0.4 && modRate <= 0.6) {
      //0.6-0.4
      correctEndOffsetRate = endOffsetRate + scrollRate;
    }
  }

  // print(
  //     "move_notify# endOffsetRate:$endOffsetRate correctEndOffsetRate:$correctEndOffsetRate modeRate:$modRate scrollRate:$scrollRate");

  /// 四舍五入
  var index = (correctEndOffsetRate + 0.5).toInt();
  return index;
}

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

Widget genarateChildWidget(BuildContext ctx, Dispatch dispatch,
    SimpleRecommandState state, int index, VideoBean videoBean) {
  bool isPlay = (index == state.latestPlayIndex);
  var preUrl =
      getRealVideoUrl(getTokenFromMem(), videoBean.id, videoBean.preUrl);
  var coverWidget = _getVideoCover(state.domin, videoBean);
  return Container(
    // padding: EdgeInsets.symmetric(vertical: Dimens.pt6),
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 视频封���和视频相关
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(ctx, 'videoPage',
                      arguments: {'videoId': videoBean.id});
                  previewModule.beginAutoPlayIfNeed();
                },
                child: Stack(
                  children: <Widget>[
                    (isPlay &&
                            (videoBean?.id ?? 0) > 0 &&
                            TextUtil.isNotEmpty(videoBean.preUrl))
                        ? PreViewVideoElement(
                            controller: getCtrl(preUrl),
                            rotateToFullScreen: false,
                            width: s.screenWidth,
                            height: Dimens.pt240,
                            unInitializedBuilder: buildUnInitializedWidget,
                            isFixWidth: false,
                            disposedWidget: coverWidget,
                          )
                        : coverWidget,
                    Positioned(
                      top: 0,
                      right: 0,
                      child: getVideoLevelWidget(
                          videoBean?.attributes?.isVip ?? false,
                          videoBean?.attributes?.needPay ?? false,
                          videoBean?.isBought ?? false,
                          videoBean?.attributes?.price ?? ""),
                    ),
                    Positioned(
                      top: Dimens.pt20,
                      left: Dimens.pt10,
                      child: (state.type == RECOMMAND_TYPE_BANGDAN)
                          ? ImageLoader.withP(ImageType.IMAGE_SVG,
                                  _getBangDangIcon(index + 1),
                                  width: Dimens.pt30, height: Dimens.pt40)
                              .load()
                          : Container(
                              width: 1,
                              height: 1,
                            ),
                    ),
                  ],
                ),
              ),

              /// 描述部分
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimens.pt16,
                    top: Dimens.pt12,
                    right: Dimens.pt16,
                    bottom: Dimens.pt8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      // "${videoBean.title}=>$index $isPlay",
                      videoBean.title,
                      style: TextStyle(
                          fontSize: t.fontSize14,
                          color: c.c333333,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _getRecommendWidget(state.type, videoBean),
                          AuthorNamesWidget(
                            authors: videoBean.actors,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 分割线
        Container(
          margin: EdgeInsets.only(bottom: Dimens.pt8),
          child: Divider(
            thickness: 1,
            color: c.cD8D8D8,
          ),
        ),
      ],
    ),
  );
}

/// 获取榜单推���的图片icon
String _getBangDangIcon(int index) {
  if (null == index) return null;
  if (index == 1) {
    return ImgCfg.MAIN_ICON_BANGDAN_1;
  } else if (index == 2) {
    return ImgCfg.MAIN_ICON_BANGDAN_2;
  } else if (index == 3) {
    return ImgCfg.MAIN_ICON_BANGDAN_3;
  }
  return null;
}

Widget _getRecommendWidget(int type, VideoBean videoBean) {
  if (null == videoBean) return Container();
  if (type == RECOMMAND_TYPE_GUANFANG) {
    return RecommendIndexWidget(index: videoBean.star);
  } else if (type == RECOMMAND_TYPE_PAOYOU) {
    return Text(
      '${videoBean.totalRecomTimes}${Lang.RECOMMAND_PAOYOU}',
      style: TextStyle(fontSize: t.fontSize12, color: c.c979797),
    );
  } else {
    return Container();
  }
}

Widget _getVideoCover(String domin, VideoBean videoBean) {
  var imgUrl =
      "$domin${(videoBean?.coverImg?.length ?? 0) <= 0 ? "" : videoBean.coverImg[0]}";
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
          imgUrl,
          width: s.screenWidth,
          height: Dimens.pt240,
          fit: BoxFit.fitWidth,
        ).load(),
      ),
      //中间的播放按钮，只有预览的时候有哦
      TextUtil.isNotEmpty(videoBean.preUrl)
          ? Center(
              child: ImageLoader.withP(
                      ImageType.IMAGE_SVG, ImgCfg.MAIN_VEDIO_PLAY,
                      width: Dimens.pt50, height: Dimens.pt50)
                  .load(),
            )
          : Container(),
    ],
  );
}
