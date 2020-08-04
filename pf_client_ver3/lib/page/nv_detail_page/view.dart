import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/main_av_page/female_list_page/components/vedio_item.dart';
import 'package:app/page/nv_detail_page/action.dart';
import 'package:app/page/nv_detail_page/effect.dart';
import 'package:app/pojo/video_bean.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:app/widget/common/defaultWidget.dart';
import 'package:app/widget/common/pullRefresh.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'state.dart';

Widget buildView(
    NvDetailState state, Dispatch dispatch, ViewService viewService) {
  final double statusBarHeight = MediaQuery.of(viewService.context).padding.top;

  Widget headDetail = Container(
    width: s.realW(360),
    child: Column(
      children: <Widget>[
        CachedNetworkImage(
          cacheManager: ImgCacheMgr(),
          imageUrl: state.otherData['domain'] + state.otherData['actorsPhoto'],
          width: s.realW(360),
          height: s.realH(200),
          fit: BoxFit.cover,
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 7.0),
          width: s.realW(330),
          child: Text(
            "${state.otherData['actorsName']}",
            style:
                TextStyle(fontSize: 16, height: 22 / 16, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 5),
          width: s.realW(330),
          child: Text(
            "${state.otherData['actorIntroduction']}",
            style: TextStyle(
                fontSize: 12, height: 17 / 12, color: Color(0xff4A4A4A)),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );

  void _onLoadMore() {
    fetchData['ids'] = state.getIds();
    fetchData['lastWatchTimes'] = state.getLastWatchTimes();
    dispatch(NvDetailActionCreator.getDetial());
  }

  return Scaffold(
    backgroundColor: Colors.white,
    body: state.isInit
        ? Center(child: new CupertinoActivityIndicator())
        : pullRefresh(
            refreshController: state.refreshController,
            enablePullDown: false,
            enablePullUp: state.actorVideos.length > 0,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: headDetail,
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 20),
                ),
                state.actorVideos.length > 0
                    ? SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.15,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Center(
                                child: VideoPreview(
                                  width: (Dimens.pt360 - 40) / 2,
                                  height: (Dimens.pt360 - 40) / 3,
                                  timeVisible: true,
                                  domain: state.otherData['domain'],
                                  data: VideoBean.fromJson(
                                      state.actorVideos[index]),
                                ),
                              );
                            },
                            childCount: state.actorVideos.length,
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: showDefaultWidget(DefaultType.noData),
                      )
              ],
            ),
            onLoading: _onLoadMore,
          ),
    floatingActionButton: SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: statusBarHeight + 10, left: 20),
        child: IconButton(
          color: Colors.red,
          icon: Text(
            "\ue5e0",
            style: TextStyle(
                fontFamily: "MaterialIcons",
                fontSize: 24.0,
                color: Colors.black,
                shadows: [
                  Shadow(color: Colors.white, blurRadius: 4.0),
                ]),
          ),
          onPressed: () {
            Navigator.of(viewService.context).pop();
          },
        ),
      ),
    ),
  );
}
