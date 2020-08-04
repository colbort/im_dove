import 'package:fish_redux/fish_redux.dart';

enum ExchangeAction { action }

class ExchangeActionCreator {
  static Action onAction() {
    return const Action(ExchangeAction.action);
  }
}
