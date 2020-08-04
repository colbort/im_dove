import 'package:fish_redux/fish_redux.dart';

class RulerState implements Cloneable<RulerState> {

  @override
  RulerState clone() {
    return RulerState();

  }
}

RulerState initState(dynamic args) {
  return RulerState();
}
