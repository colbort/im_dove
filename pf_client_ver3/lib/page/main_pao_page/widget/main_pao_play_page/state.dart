import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

class MainPaoPlayState implements Cloneable<MainPaoPlayState> {
  PaoDataModel data;
  @override
  MainPaoPlayState clone() {
    return MainPaoPlayState()..data = data;
  }
}

MainPaoPlayState initState(Map<String, dynamic> args) {
  return MainPaoPlayState()..data = args["data"];
}
