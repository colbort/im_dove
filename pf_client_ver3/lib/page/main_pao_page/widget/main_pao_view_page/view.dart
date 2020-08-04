import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPaoViewState state, Dispatch dispatch, ViewService viewService) {
  getItemWidget() {
    if (state.bloggerItemList.length > 0 && state.stype == 0) {
      return Container(
        child: pullRefresh(
          enablePullUp: false,
          refreshController: state.refreshController,
          onLoading: () {
            dispatch(MainPaoViewActionCreator.onLoadMore());
          },
          onRefresh: () {
            dispatch(MainPaoViewActionCreator.onRefresh());
          },
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: state.bloggerItemList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
                  padding: EdgeInsets.symmetric(vertical: Dimens.pt6),
                  width: Dimens.pt328,
                  child: Text(
                    Lang.HOT_POST_TUIJIAN,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              }
              return BloggerItemWidget(
                data: state.bloggerItemList[index - 1],
                dispatch: dispatch,
                viewService: viewService,
              );
            },
          ),
        ),
      );
    }
    if (state.dataList.length == 0) {
      return Container(
        child: showLoadingWidget(true),
      );
    }

    return pullRefresh(
      refreshController: state.refreshController,
      onLoading: () {
        dispatch(MainPaoViewActionCreator.onLoadMore());
      },
      onRefresh: () {
        dispatch(MainPaoViewActionCreator.onRefresh());
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: viewService.buildComponent(componentList),
          ),
        ],
      ),
    );

    // return Container(
    //   child: NotificationListener(
    //     onNotification: (notification) {
    //       if (notification is ScrollStartNotification) {
    //         var start = notification;
    //         _startScrollOffset = start.metrics.pixels;
    //         log.i("开始滚动startScrollOffset:$_startScrollOffset");
    //       } else if (notification is ScrollEndNotification) {
    //         var end = notification;
    //         _endScrollOffset = end.metrics.pixels;
    //         log.i("停止滚动_endScrollOffset:$_endScrollOffset");

    //         final task = Task3(
    //             runnable: Runnable(
    //           arg1: _startScrollOffset,
    //           arg2: _endScrollOffset,
    //           arg3: _maxItemHeight,
    //           fun3: computeIndex,
    //         ));
    //         Executor().addTask(task: task).listen((resultIndex) {
    //           l.d("move_notify",
    //               "滚动停止: index:$resultIndex enable:${previewModule.enable}");
    //           if (resultIndex >= 0) {
    //             previewModule.lastPlayIndex = resultIndex;
    //             previewModule.beginAutoPlayIfNeed();
    //             // dispatch(SimpleRecommandActionCreator.onAutoPlayUI(resultIndex));
    //           }
    //         }).onError((e) {
    //           l.d("move_notify", "滚动停止: error:$e");
    //         });
    //         // previewModule.lastPlayIndex = index;
    //         // l.d('move_notify',
    //         //     "滚动停止endscrollOffset:$_endScrollOffset   endOffsetRate:$endOffsetRate  mod:$modRate correct:$correctEndOffsetRate  index:$index");
    //         // dispatch(SimpleRecommandActionCreator.onAutoPlayUI(index));
    //       }
    //       return true;
    //     },
    //     child: pullRefresh(
    //       refreshController: state.refreshController,
    //       onLoading: () {
    //         dispatch(MainPaoViewActionCreator.onLoadMore());
    //       },
    //       onRefresh: () {
    //         dispatch(MainPaoViewActionCreator.onRefresh());
    //       },
    //       child: CustomScrollView(
    //         slivers: <Widget>[
    //           SliverToBoxAdapter(
    //             child: viewService.buildComponent(componentList),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  return getItemWidget();
}

/// 博主item
class BloggerItemWidget extends StatefulWidget {
  final PaoBloggerModel data;
  final Dispatch dispatch;
  final ViewService viewService;

  const BloggerItemWidget({this.data, this.dispatch, this.viewService});

  @override
  BloggerItemWidgetState createState() => BloggerItemWidgetState();
}

class BloggerItemWidgetState extends State<BloggerItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Dimens.pt12),
        ),
        getUserDataWidget(),
        Padding(
          padding: EdgeInsets.only(top: Dimens.pt12),
        ),
        getHengLine(h: 4, color: c.cD8D8D8),
      ],
    ));
  }

  /// 获取用户数据widget
  Widget getUserDataWidget() {
    if (widget.data == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  var mineData = getMineModel();
                  if (mineData == null) return;
                  if (widget.data == null || widget.data.userId == null) return;
                  if (widget.data.userId == mineData.userId) return;
                  Navigator.of(widget.viewService.context)
                      .pushNamed(page_main_pao_other, arguments: {
                    "userId": widget.data.userId,
                    "name": widget.data.name
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      /// 头像
                      widget.data.headImg.isEmpty
                          ? SvgPicture.asset(
                              'assets/mine/default_man.svg',
                              width: Dimens.pt40,
                              height: Dimens.pt40,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(Dimens.pt45),
                              child: CachedNetworkImage(
                                imageUrl: getImgDomain() + widget.data.headImg,
                                cacheManager: ImgCacheMgr(),
                                width: Dimens.pt40,
                                height: Dimens.pt40,
                                fit: BoxFit.cover,
                              ),
                            ),

                      /// 名称 等级 时间 位置
                      Container(
                        margin: EdgeInsets.only(left: Dimens.pt6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                /// 名称
                                Text(
                                  widget.data.name,
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontSize: 14, height: 17 / 14),
                                ),

                                getVipLvWidget(
                                    w: Dimens.pt50, lv: widget.data.vipLv),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: Dimens.pt6),
                              // padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: <Widget>[
                                  /// 地址icon
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    child:
                                        SvgPicture.asset(ImgCfg.MAIN_PAO_ADDR),
                                  ),

                                  /// 地址
                                  Container(
                                    padding: EdgeInsets.only(left: 2),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.data.addr,
                                      style: TextStyle(
                                          fontSize: 12, color: c.c9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 关注
              widget.data.bWatch
                  ? Container(
                      alignment: Alignment.center,
                      width: Dimens.pt78,
                      height: Dimens.pt28,
                      child: Text(
                        Lang.YIGUANZHU,
                        style: TextStyle(fontSize: 14, color: c.cC9C9C9),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        print("�����注");
                        widget.dispatch(MainPaoViewActionCreator.onAttention(
                            widget.data.userId));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: Dimens.pt78,
                        height: Dimens.pt28,
                        decoration: BoxDecoration(
                          color: c.cFFE300,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                        child: Text(
                          Lang.GUANZHU,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: Dimens.pt46, top: Dimens.pt8),
            width: Dimens.pt280,
            child: Text(
              widget.data.intro,
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
