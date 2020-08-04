import 'package:fish_redux/fish_redux.dart';

enum SetPageAction { getUniversalData}

class SetPageActionCreator {
  static Action getUniversalData(Map<String, dynamic> data) {
    return Action(SetPageAction.getUniversalData, payload: data);
  }

}
