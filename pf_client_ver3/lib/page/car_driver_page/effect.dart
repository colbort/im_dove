import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

Effect<CarDriverState> buildEffect() {
  return combineEffects(<Object, Effect<CarDriverState>>{
    Lifecycle.initState: _onAction,
  });
}

Future _onAction(Action action, Context<CarDriverState> ctx) async {
  final res = await net.request(Routers.GROUP_QUERY_GET, method: 'get');
  if (res.code == 200) {
    ctx.dispatch(CarDriverActionCreator.onSaveGroup(res.data['data']));
  }
}
