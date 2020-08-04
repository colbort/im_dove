import 'package:fish_redux/fish_redux.dart';

class PwKeyBoardState implements Cloneable<PwKeyBoardState> {
  List<String> sNumList = [];
  List<String> sCharList = [];

  @override
  PwKeyBoardState clone() {
    return PwKeyBoardState()
      ..sNumList = sNumList
      ..sCharList = sCharList;
  }
}
