import 'package:fish_redux/fish_redux.dart';

enum FemaleListPageAction {
  saveFamaleList,
  changeLetter,
  changeListType,
  changeLetterList
}

class FemaleListPageActionCreator {
  static Action changeLetter(int index) {
    return Action(FemaleListPageAction.changeLetter, payload: index);
  }

  static Action changeLetterList(List list) {
    return Action(FemaleListPageAction.changeLetterList, payload: list);
  }

  static Action changeListType(int tabIndex) {
    return Action(FemaleListPageAction.changeListType, payload: tabIndex);
  }

  static Action saveFamaleList(data) {
    return Action(FemaleListPageAction.saveFamaleList, payload: data);
  }
}
