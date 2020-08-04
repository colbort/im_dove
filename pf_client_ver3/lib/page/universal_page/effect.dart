import 'package:app/net/net.dart';
import 'package:app/net/routers.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';


Effect<UniversalPageState> buildEffect() {
  return combineEffects(<Object, Effect<UniversalPageState>>{
    Lifecycle.initState: _onAction,
  });
}

void _onAction(Action action, Context<UniversalPageState> ctx) async {
  final resp = await net.request(Routers.INCOME, method: 'get');
  if (resp.code == 200) {
    ctx.dispatch(SetPageActionCreator.getUniversalData(resp.data));
  }

}
