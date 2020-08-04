import 'package:app/player/video_player/custom_video_control.dart';
import 'package:fish_redux/fish_redux.dart';

enum VideoComAction {
  action,
  showVideoTopUi,
  freshVideoUrl,
  freshUpdateCallback,
  freshPayState,
  freshCanWatch,
}

class VideoComActionCreator {
  static Action onAction() {
    return const Action(VideoComAction.action);
  }

  static Action onShowVideoTopUi(bool show) {
    return Action(VideoComAction.showVideoTopUi, payload: show);
  }

  static Action onFreshVideoUrl(
      String url, Function(CustomVideoController) updateCallBack) {
    return Action(VideoComAction.freshVideoUrl,
        payload: {'url': url, 'updateCallBack': updateCallBack});
  }

  static Action onFreshUpdateCallBack(
      Function(CustomVideoController) updateCallBack) {
    return Action(VideoComAction.freshUpdateCallback, payload: updateCallBack);
  }

  static Action onFreshPayStateAction(
      bool canWatch, int reason, String price, double wallet) {
    return Action(VideoComAction.freshPayState, payload: {
      'canWatch': canWatch,
      'reason': reason,
      'price': price,
      'wallet': wallet
    });
  }

  static Action onFreshCanWatchAction(bool canWatch) {
    return Action(VideoComAction.freshCanWatch, payload: canWatch);
  }
}
