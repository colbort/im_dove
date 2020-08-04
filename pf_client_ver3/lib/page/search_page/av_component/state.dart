import 'package:app/model/search_final_resp.dart';
import 'package:fish_redux/fish_redux.dart';

class AvState implements Cloneable<AvState> {
  List<SearchResp> searchResp;

  @override
  AvState clone() {
    return AvState()..searchResp = searchResp;
  }
}

AvState initState(Map<String, dynamic> args) {
  return AvState()..searchResp = [];
}
