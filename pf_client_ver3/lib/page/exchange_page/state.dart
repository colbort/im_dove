import 'package:fish_redux/fish_redux.dart';

class ExchangeState implements Cloneable<ExchangeState> {

  @override
  ExchangeState clone() {
    return ExchangeState();
  }
}

ExchangeState initState(Map<String, dynamic> args) {
  return ExchangeState();
}
