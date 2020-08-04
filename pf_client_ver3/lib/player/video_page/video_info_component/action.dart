import 'package:app/player/video_page/model/ad_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum VideoInfoAction {
  action,
  getVideoInfo,
  updateInfo,
  updateRecommentVideoList,
  updateAdInfo,
  resetInfo,
  doLike,
  doUnlike,
  doFavorite,
  freshLike,
  freshUnlike,
  freshFavorite,
  freshCanWatch,
}

class VideoInfoActionCreator {
  static Action onGetVideoInfo(int videoId) {
    return Action(VideoInfoAction.getVideoInfo, payload: videoId);
  }

  static Action onUpdateInfo(args) {
    return Action(VideoInfoAction.updateInfo, payload: args);
  }

  static Action onUpdateAdInfo(List<AdModel> adModels) {
    return Action(VideoInfoAction.updateAdInfo, payload: adModels);
  }

  static Action onResetInfo(int videoId) {
    return Action(VideoInfoAction.resetInfo, payload: videoId);
  }

  static Action onDoLike() {
    return Action(VideoInfoAction.doLike);
  }

  static Action onDoUnlike() {
    return Action(VideoInfoAction.doUnlike);
  }

  static Action onDoFavorite() {
    return Action(VideoInfoAction.doFavorite);
  }

  static Action onFreshLike(args) {
    return Action(VideoInfoAction.freshLike, payload: args);
  }

  static Action onFreshUnLike(args) {
    return Action(VideoInfoAction.freshUnlike, payload: args);
  }

  static Action onFreshFavorite(args) {
    return Action(VideoInfoAction.freshFavorite, payload: args);
  }

  static Action updateRecommentVideoList(List videoList) {
    return Action(VideoInfoAction.updateRecommentVideoList, payload: videoList);
  }

  static Action onFreshCanWatch(bool canWatch) {
    return Action(VideoInfoAction.freshCanWatch, payload: canWatch);
  }
}
