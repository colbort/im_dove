import 'package:fish_redux/fish_redux.dart';

enum VideoAction {
  action,
  showVideoDialog,
  closeVideoDialog,
  onBuyVideo,
  freshVideoId,
}

class VideoActionCreator {
  static Action onAction() {
    return const Action(VideoAction.action);
  }

  static Action showVideoDialogAction(int reason, String price, double wallet) {
    return Action(VideoAction.showVideoDialog,
        payload: {'reason': reason, 'price': price, 'wallet': wallet});
  }

  static Action closeVideoDialogAction() {
    return const Action(VideoAction.closeVideoDialog);
  }

  static Action onBuyVideo(int id) {
    return Action(VideoAction.onBuyVideo, payload: id);
  }

  static Action onFreshVideoId(int id) {
    return Action(VideoAction.freshVideoId, payload: id);
  }
}
