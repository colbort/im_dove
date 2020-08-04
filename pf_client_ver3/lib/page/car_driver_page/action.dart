import 'package:fish_redux/fish_redux.dart';

enum CarDriverAction { onSaveGroup }

class CarDriverActionCreator {
  static Action onSaveGroup(data) {
    return Action(CarDriverAction.onSaveGroup, payload: data);
  }
}
