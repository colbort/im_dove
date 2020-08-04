import 'package:fish_redux/fish_redux.dart';

enum BootAction { countDown, enter, fresh, adInfo, freshAniState }

class BootActionCreator {
  static Action onCountDownAction(bool countDown) {
    return Action(BootAction.countDown, payload: countDown);
  }

  static Action onEnterAction() {
    return Action(BootAction.enter);
  }

  static Action onFreshAction() {
    return Action(BootAction.fresh);
  }

  static Action onFreshAniState(bool state) {
    return Action(BootAction.freshAniState, payload: state);
  }

  static Action onAdInfo(bool getAdImg, String adImgUrl, String jumpUrl) {
    return Action(BootAction.adInfo, payload: {
      'getAdImg': getAdImg,
      'adImgUrl': adImgUrl,
      'jumpUrl': jumpUrl
    });
  }
}
