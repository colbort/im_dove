import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ExchangeState> buildEffect() {
  return combineEffects(<Object, Effect<ExchangeState>>{
    ExchangeAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ExchangeState> ctx) {
}
