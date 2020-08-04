import 'package:fish_redux/fish_redux.dart';

enum NvDetailAction {
  getDetial,

  saveActorsDetail,
}

class NvDetailActionCreator {
  static Action getDetial() {
    return Action(NvDetailAction.getDetial);
  }

  static Action saveActorsDetail(data) {
    return Action(NvDetailAction.saveActorsDetail, payload: data);
  }
}
