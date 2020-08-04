import 'package:fish_redux/fish_redux.dart';

enum SetPageAction { changePwChecked, saveVersion, saveImageCache, changePhone }

class SetPageActionCreator {
  static Action onChangePwChecked(bool isChecked) {
    return Action(SetPageAction.changePwChecked, payload: isChecked);
  }

  static Action onChangePhone(String phone) {
    return Action(SetPageAction.changePhone, payload: phone);
  }

  static Action onSaveVersion(String version) {
    return Action(SetPageAction.saveVersion, payload: version);
  }

  static Action onSaveImageCache(double imageCache) {
    return Action(SetPageAction.saveImageCache, payload: imageCache);
  }
}
