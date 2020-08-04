import 'package:app/player/video_page/model/video_model.dart';
import 'package:app/storage/movie_cache.dart';
import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

import 'package:app/player/video_page/video_element.dart' as videoElement;

Reducer<VideoInfoState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoInfoState>>{
      VideoInfoAction.resetInfo: _resetInfo,
      VideoInfoAction.updateInfo: _updateInfo,
      VideoInfoAction.freshLike: _updateLike,
      VideoInfoAction.freshUnlike: _updateUnlike,
      VideoInfoAction.freshFavorite: _updateFavorite,
      VideoInfoAction.updateAdInfo: _updateAdInfo,
      VideoInfoAction.updateRecommentVideoList: _updateRecommendVideoList,
      VideoInfoAction.freshCanWatch: _freshCanWatch,
    },
  );
}

VideoInfoState _resetInfo(VideoInfoState state, Action action) {
  //切换视频存储上一个视频信息
  if (videoElement.controller != null &&
      videoElement.controller.totalSeconds > 0) {
    viewRecord.saveMovie(
        state.videoId.toString(),
        state.videoTitle,
        state.coverUrl,
        videoElement.controller.playedSeconds,
        videoElement.controller.totalSeconds,
        false);
  }

  final VideoInfoState newState = VideoInfoState()
    ..videoId = action.payload
    ..videoTitle = '...'
    ..coverUrl = ''
    ..playTime = 0
    ..videoWatch = 0
    ..likes = 0
    ..isLike = false
    ..unlikes = 0
    ..isUnlike = false
    ..isFavorite = false
    ..canWatch = true
    ..reason = 0
    ..recommendVideoList = []
    ..videoModel = null
    ..attributes = null
    ..adModels = []
    ..snapToEnd = true;
  return newState;
}

VideoInfoState _updateInfo(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  VideoModel videoModel = action.payload['videoModel'];
  newState.videoTitle = videoModel.video.title;
  newState.coverUrl = videoModel.video.coverImgList.first;
  newState.playTime = videoModel.video.playTime;
  newState.videoWatch = videoModel.video.totalWatchTimes;
  newState.isLike = videoModel.isLike;
  newState.likes = videoModel.video.totalLikes;
  newState.isUnlike = videoModel.isUnLike;
  newState.unlikes = videoModel.video.totalUnLikes;
  newState.isFavorite = videoModel.isCollect;
  newState.canWatch = videoModel.canWatch;
  newState.reason = videoModel.reason;
  newState.price = videoModel.video.attributes.price;
  newState.wallet = double.parse(videoModel.balance);
  newState.attributes = videoModel.video.attributes;
  // newState.recommendVideoList = videoModel.recommendVideoList.map((f) {
  //   var vw = VideoWarp()
  //     ..id = f.id
  //     ..title = f.title
  //     ..coverImgList = f.coverImgList
  //     ..totalWatchTimes = f.totalWatchTimes
  //     ..tagList = f.tagList
  //     ..actors = f.actors
  //     ..playTime = f.playTime
  //     ..attributes = f.attributes
  //     ..bango = f.bango;
  //   return vw;
  // }).toList();
  return newState;
}

VideoInfoState _updateAdInfo(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  newState.adModels = action.payload;
  return newState;
}

VideoInfoState _updateRecommendVideoList(VideoInfoState state, Action action) {
  var recommendVideoList = action.payload;
  final VideoInfoState newState = state.clone();
  newState.recommendVideoList =
      List<VideoWarp>.from(recommendVideoList.map((f) {
    VideoWarp vw = VideoWarp()
      ..id = f.id
      ..title = f.title
      ..coverImgList = f.coverImgList
      ..totalWatchTimes = f.totalWatchTimes
      ..tagList = f.tagList
      ..actors = f.actors
      ..playTime = f.playTime
      ..attributes = f.attributes
      ..bango = f.bango
      ..isBought = f.isBought;
    return vw;
  }).toList());
  return newState;
}

VideoInfoState _updateLike(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  newState.snapToEnd = false;
  newState.likes = action.payload['likes'];
  newState.isLike = action.payload['isLike'];
  return newState;
}

VideoInfoState _updateUnlike(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  newState.snapToEnd = false;
  newState.unlikes = action.payload['unlikes'];
  newState.isUnlike = action.payload['isUnlike'];
  return newState;
}

VideoInfoState _updateFavorite(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  newState.snapToEnd = false;
  newState.isFavorite = action.payload['isFavorite'];
  return newState;
}

VideoInfoState _freshCanWatch(VideoInfoState state, Action action) {
  final VideoInfoState newState = state.clone();
  newState.canWatch = action.payload;
  return newState;
}
