import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

class MainPaoItemState implements Cloneable<MainPaoItemState> {
  PaoDataModel paoDataModel;

  bool bShowUserData = true;
  @override
  MainPaoItemState clone() {
    return MainPaoItemState()
      ..paoDataModel = paoDataModel
      ..bShowUserData = bShowUserData;
  }
}

MainPaoItemState initState(Map<String, dynamic> args) {
  return MainPaoItemState();
}
