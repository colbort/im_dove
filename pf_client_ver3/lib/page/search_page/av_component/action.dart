import 'package:fish_redux/fish_redux.dart';

enum AvAction { onSearchData, onSearchNextData }

class AvActionCreator {
  static Action onSearchData(String keyword) {
    return Action(AvAction.onSearchData);
  }

  static Action onSearchNextData(String keyword, int skin, int limit) {
    return Action(AvAction.onSearchNextData);
  }
}
