import 'package:fish_redux/fish_redux.dart';

enum MainMineAction {
  getInfo,
  saveInfo,
  getChat,
  fetchWalletCount,
  changePwChecked,
  saveVersion,
  saveImageCache,
  changePhone,
}

class MainMineActionCreator {
  static Action getInfo() {
    return Action(MainMineAction.getInfo);
  }

  static Action saveInfo(data) {
    return Action(MainMineAction.saveInfo, payload: data);
  }

  static Action fetchWalletCount(display) {
    return Action(MainMineAction.fetchWalletCount, payload: display);
  }

  static Action onChangePwChecked(bool isChecked) {
    return Action(MainMineAction.changePwChecked, payload: isChecked);
  }

  static Action onChangePhone(String phone) {
    return Action(MainMineAction.changePhone, payload: phone);
  }

  static Action onSaveVersion(String version) {
    return Action(MainMineAction.saveVersion, payload: version);
  }

  static Action onSaveImageCache(double imageCache) {
    return Action(MainMineAction.saveImageCache, payload: imageCache);
  }
}
