import 'package:fish_redux/fish_redux.dart';

class CarDriverState implements Cloneable<CarDriverState> {
  List group;
  @override
  CarDriverState clone() {
    return CarDriverState()..group = group;
  }
}

CarDriverState initState(Map<String, dynamic> args) {
  return CarDriverState()..group = [];
}
