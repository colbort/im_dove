import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/player/video_page/action.dart';
import 'package:app/player/video_page/model/ad_model.dart';
import 'package:app/player/video_page/model/attributes.dart';
import 'package:app/player/video_page/model/video.dart';
import 'package:app/player/video_page/model/video_model.dart';
import 'package:app/player/video_page/video_component/action.dart';
import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoInfoState> buildEffect() {
  return combineEffects(<Object, Effect<VideoInfoState>>{
    VideoInfoAction.action: _onAction,
    Lifecycle.initState: _onInitState,
    VideoInfoAction.getVideoInfo: _onGetVideoInfo,
    VideoInfoAction.doLike: _onDoLike,
    VideoInfoAction.doUnlike: _onDoUnlike,
    VideoInfoAction.doFavorite: _onDoFavorite,
  });
}

void _onAction(Action action, Context<VideoInfoState> ctx) {}

Future<dynamic> getSingleVideoInfo(int videoId, BuildContext context) async {
  var resp = await net.request(Routers.VIDEO_PlAY_POST, args: {'id': videoId});

  if (resp.code != 200) {
    var rlt = await showConfirm(context,
        hasCancel: true, child: Text(Lang.WANGLUOCUOWU));
    if (rlt) {
      return getSingleVideoInfo(videoId, context);
    } else {
      return null;
    }
  } else {
    return resp.data;
  }
}

void _onGetVideoAdInfo(Context<VideoInfoState> ctx) async {
  //  获取av广告
  var adData = await net.request(Routers.AD_APPADS_POST, args: {"location": 3});
  if (adData.code != 200) return;
  String domain = adData.data['domain'];
  List adModels = adData.data['adModels'];
  //  组装 img = domain + img
  List<AdModel> models = [];
  for (Map m in adModels) {
    m['img'] = domain + m['img'];
    var model = AdModel.fromJson(m);
    models.add(model);
  }
  ctx.dispatch(VideoInfoActionCreator.onUpdateAdInfo(models));
}

void _onGetRecommentVideoList(
    Context<VideoInfoState> ctx, var imgDoamin, int videoId) async {
  //  获取av推荐列表
  var adData =
      await net.request(Routers.VIDEO_PLAY_RECOMMENT, args: {'id': videoId});
  if (adData.code != 200) return;
  if (adData.data == null || adData.data['videos'] == null) return;

  var recommendVideoList = List.from(adData.data['videos']).map((e) {
    int id = e['id'];
    String title = e['title'];
    int playTime = e['playTime'];
    List actors = e['actors'];
    List tags = e['tags'];
    int totalWatchTimes = e['totalWatchTimes'];
    List<String> coverImgList = List<String>.from(e['coverImg']).map((e) {
      String result = imgDoamin;
      if (!result.endsWith('/')) {
        result += '/';
      }
      return result += e;
    }).toList();
    String bango = e['bango'];
    return Video(
      id: id,
      title: title,
      coverImgList: coverImgList,
      playTime: playTime,
      tagList: tags,
      totalWatchTimes: totalWatchTimes,
      actors: actors,
      bango: bango,
      attributes: Attributes.fromJson(e['attributes']),
    );
  }).toList();

  ctx.dispatch(
      VideoInfoActionCreator.updateRecommentVideoList(recommendVideoList));
}

void _onGetVideoInfo(Action action, Context<VideoInfoState> ctx) async {
  var videoId = action.payload;
  //获取视频信息
  var data = await getSingleVideoInfo(videoId, ctx.context);
  if (data == null) {
    return;
  }

  //初始化视频模型
  var token = await getToken();
  VideoModel videoModel = VideoModel.fromJson(token, data);
  var updateCallBack = (CustomVideoController ctrl) {
    if (!videoModel.canWatch) {
      if (ctrl.value.position.inSeconds >=
          videoModel.video.attributes.preview) {
        if (ctrl.value.isPlaying) {
          if (ctrl.isFullScreen) {
            log.i('退出全屏');
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
          ctrl.pause();
          ctx.dispatch(VideoActionCreator.showVideoDialogAction(
              videoModel.reason,
              videoModel.video.attributes.price,
              double.parse(videoModel.balance)));
        }
      }
    }
  };
  ctx.dispatch(VideoComActionCreator.onFreshPayStateAction(
    videoModel.canWatch,
    videoModel.reason,
    videoModel.video.attributes.price,
    double.parse(videoModel.balance),
  ));
  ctx.dispatch(VideoComActionCreator.onFreshVideoUrl(
      videoModel.video.videoUrl, updateCallBack));

  ctx.dispatch(VideoInfoActionCreator.onUpdateInfo({
    'videoModel': videoModel,
  }));

  //获取推荐列表
  _onGetRecommentVideoList(ctx, videoModel.domain, videoId);

  _onGetVideoAdInfo(ctx);

  //获取视频状态
  var resData =
      await net.request(Routers.CHECK_VIDEO_STATUS_GET, args: {"id": videoId});

  ///视频在服务器已经移除
  if (!(resData.code == 200 &&
      resData.data != null &&
      resData.data["status"] != 1)) {
    if (Navigator.of(ctx.context).canPop()) Navigator.of(ctx.context).pop();
    showToast(Lang.VIDEO_REMOVED, type: ToastType.negative);
  }
}

void _onInitState(Action action, Context<VideoInfoState> ctx) async {}

void _onDoLike(Action action, Context<VideoInfoState> ctx) {
  //判断是否点赞，点踩同时存在
  if (ctx.state.isUnlike) {
    return;
  }

  var like = false;
  var likes = 0;
  if (ctx.state.isLike) {
    like = false;
    likes = ctx.state.likes - 1;
    var url = Routers.USERVIDEO_DELETERECORD_POST;
    net.request(url,
        args: {"type": 1, "videoId": ctx.state.videoId, "videoType": 1});
  } else {
    like = true;
    likes = ctx.state.likes + 1;
    var url = Routers.USERVIDEO_ADDRECORD_POST;
    net.request(url,
        args: {"type": 1, "videoId": ctx.state.videoId, "videoType": 1});
  }
  ctx.dispatch(
      VideoInfoActionCreator.onFreshLike({'isLike': like, "likes": likes}));
}

void _onDoUnlike(Action action, Context<VideoInfoState> ctx) {
  //判断是否点赞，点踩同时存在
  if (ctx.state.isLike) {
    return;
  }

  var unlike = false;
  var unlikes = 0;

  if (ctx.state.isUnlike) {
    unlike = false;
    unlikes = ctx.state.unlikes - 1;
    var url = Routers.USERVIDEO_DELETERECORD_POST;
    net.request(url,
        args: {"type": 2, "videoId": ctx.state.videoId, "videoType": 1});
  } else {
    unlike = true;
    unlikes = ctx.state.unlikes + 1;
    var url = Routers.USERVIDEO_ADDRECORD_POST;
    net.request(url,
        args: {"type": 2, "videoId": ctx.state.videoId, "videoType": 1});
  }
  ctx.dispatch(VideoInfoActionCreator.onFreshUnLike(
      {'isUnlike': unlike, "unlikes": unlikes}));
}

void _onDoFavorite(Action action, Context<VideoInfoState> ctx) {
  if (ctx.state.isFavorite) {
    var url = Routers.USERVIDEO_DELETERECORD_POST;
    net.request(url,
        args: {"type": 3, "videoId": ctx.state.videoId, "videoType": 1});
  } else {
    var url = Routers.USERVIDEO_ADDRECORD_POST;
    net.request(url,
        args: {"type": 3, "videoId": ctx.state.videoId, "videoType": 1});
  }
  ctx.dispatch(VideoInfoActionCreator.onFreshFavorite(
      {'isFavorite': !ctx.state.isFavorite}));
}
