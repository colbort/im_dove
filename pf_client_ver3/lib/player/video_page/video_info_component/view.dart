import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/player/video_page/action.dart';
import 'package:app/player/video_page/vedioItems/rowItem.dart';
import 'package:app/player/video_page/video_component/action.dart';
import 'package:app/utils/dimens.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/utils/screen.dart';

Widget buildView(
    VideoInfoState state, Dispatch dispatch, ViewService viewService) {
  return Expanded(
    child: buildIntroduce(state, dispatch, viewService),
  );
}

Widget buildIntroduce(
    VideoInfoState state, Dispatch dispatch, ViewService viewService) {
  var randIdx = 0;
  if (state.adModels.length > 1) {
    // var rng = new Random();
    // randIdx = rng.nextInt(state.adModels.length);
    //去掉随机使用最后一条广告
    randIdx = state.adModels.length - 1;
  }

  return InkWell(
    child: CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              buildInfoWight(state, dispatch, viewService),
              SizedBox(height: 10),
              state.adModels.length > 0
                  ? GestureDetector(
                      onTap: () {
                        launch(state.adModels[randIdx].jumpURL);
                      },
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: state.adModels[randIdx].img,
                          // imageUrl:
                          //     'https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=92afee66fd36afc3110c39658318eb85/908fa0ec08fa513db777cf78376d55fbb3fbd9b3.jpg',
                          cacheManager: ImgCacheMgr(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 7.0,
              ),
              buildHeader(),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          sliver: SliverFixedExtentList(
            itemExtent: s.realH(118),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //创建列表项
                return Container(
                  // color: Colors.red,
                  padding: EdgeInsets.only(bottom: s.realH(8)),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: buildCell(index, state, dispatch, viewService),
                  ),
                );
              },
              childCount: state.recommendVideoList.length ?? 0,
            ),
          ),
        )
      ],
    ),
  );
}

Widget buildInfoWight(
    VideoInfoState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(5.0)),
        _buildText(
          state.videoTitle,
          TextStyle(
            fontSize: 16,
            color: Color(0xff010001),
          ),
        ),
        _buildText(
          '${state.videoWatch}次观看',
          TextStyle(
            fontSize: 12,
            color: Color(0xcc010001),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // color: Colors.red,
              width: MediaQuery.of(viewService.context).size.width / 3,
              height: 45,
              child: GestureDetector(
                onTap: () {
                  dispatch(VideoInfoActionCreator.onDoLike());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      child: SvgPicture.asset(
                        state.isLike
                            ? 'assets/player/info_buttons/like_selected.svg'
                            : 'assets/player/info_buttons/like_normal.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 4.0, 0, 0),
                      child: Text(
                        '${state.likes ?? 0}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff666666),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              width: MediaQuery.of(viewService.context).size.width / 3,
              height: 45,
              child: GestureDetector(
                onTap: () {
                  dispatch(VideoInfoActionCreator.onDoUnlike());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      child: SvgPicture.asset(
                        state.isUnlike
                            ? 'assets/player/info_buttons/unlike_selected.svg'
                            : 'assets/player/info_buttons/unlike_normal.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 4.0, 0, 0),
                      child: Text(
                        '${state.unlikes ?? 0}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff666666),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.red,
              width: MediaQuery.of(viewService.context).size.width / 3,
              height: 65,
              child: GestureDetector(
                onTap: () {
                  dispatch(VideoInfoActionCreator.onDoFavorite());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      child: SvgPicture.asset(
                        state.isFavorite
                            ? 'assets/player/info_buttons/collect_selected.svg'
                            : 'assets/player/info_buttons/collect_normal.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 4.0, 0, 0),
                      child: Text(
                        Lang.SHOUCANG,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff666666),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),

        Center(child: buildVipPayWidget(state, dispatch, viewService)),

        //MARK:间隙
        SizedBox(
          height: 8,
        ),

        //MARK:分割
        Container(
          height: 0.5,
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          color: Colors.black.withOpacity(0.5),
        ),
      ],
    ),
  );
}

//WIDGET:创建文字
Widget _buildText(String text, TextStyle style) {
  return Padding(
    padding: EdgeInsets.only(left: 8),
    child: Text(
      text,
      maxLines: 3,
      style: style,
    ),
  );
}

Widget buildHeader() {
  return Container(
    // color: Colors.red,
    margin: const EdgeInsets.fromLTRB(8, 0, 0, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 8),
          color: Color(0xffffd952),
          width: 4,
          height: 20,
        ),
        Text(
          Lang.CAINIXIHUAN,
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}

Widget buildVipPayWidget(
    VideoInfoState state, Dispatch dispatch, ViewService viewService) {
  if (state.canWatch) {
    return Container();
  }
  //vip专享视频
  if (state.reason == 2) {
    return GestureDetector(
      onTap: () {
        dispatch(VideoActionCreator.showVideoDialogAction(
            state.reason, state.price, state.wallet));
      },
      child: Container(
        height: 40,
        width: Dimens.pt328,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xfffbe400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 26,
              child: SvgPicture.asset(
                'assets/player/page/vip.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 2, 0, 0),
              child: Text(
                Lang.BUYMEMBER,
                style: TextStyle(fontSize: 14, color: Color(0xff98360c)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //付费视频
  if (state.reason == 3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Container(
            width: 36,
            height: 36,
            child: SvgPicture.asset(
              'assets/player/page/bigDiamond.svg',
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            dispatch(VideoActionCreator.showVideoDialogAction(
                state.reason, state.price, state.wallet));
          },
          child: Container(
            height: 40,
            width: Dimens.pt276,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xfffbe400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 4, 0),
                  child: Text(
                    Lang.AV_PURCHASE + "  |",
                    style: TextStyle(fontSize: 14, color: Color(0xff98360c)),
                  ),
                ),
                Container(
                  width: 30,
                  height: 26,
                  child: SvgPicture.asset(
                    'assets/player/page/smallDiamond.svg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 2, 0, 0),
                  child: Text(
                    state.price ?? '0',
                    style: TextStyle(fontSize: 14, color: Color(0xff98360c)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  return Container();
}

Widget buildCell(int index, VideoInfoState state, Dispatch dispatch,
    ViewService viewService) {
  //MARK:获取推荐视频对象
  var video = state.recommendVideoList[index];
  //标题拼接番号
  var bg = video.bango == null || video.bango.isEmpty ? "" : "[${video.bango}]";

  var title = bg + video.title;

  // print(title);
  return Stack(
    children: <Widget>[
      Positioned.fill(
        child: vedioRowItem(
            title: title,
            imgUrl: video.coverImgList.first,
            tags: video.tagList != null
                ? video.tagList.map((f) => f['name']).toList()
                : [],
            timeLong: video.playTime,
            watchTimes: video.totalWatchTimes,
            actors: video.actors.length > 0 ? video.actors.first['name'] : null,
            isVipVideo: video.attributes.isVip,
            isPayVideo: video.attributes.needPay,
            isPayed: video.isBought,
            price: video.attributes.price,
            tapVideo: () {
              dispatch(VideoActionCreator.onFreshVideoId(video.id));
              dispatch(VideoComActionCreator.onFreshVideoUrl('', null));
              dispatch(VideoInfoActionCreator.onResetInfo(video.id));
              dispatch(VideoInfoActionCreator.onGetVideoInfo(video.id));
            }),
      ),
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            dispatch(VideoActionCreator.onFreshVideoId(video.id));
            dispatch(VideoComActionCreator.onFreshVideoUrl('', null));
            dispatch(VideoInfoActionCreator.onResetInfo(video.id));
            dispatch(VideoInfoActionCreator.onGetVideoInfo(video.id));
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
      )
    ],
  );
}
