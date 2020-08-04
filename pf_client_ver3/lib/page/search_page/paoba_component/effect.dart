import 'package:app/net/net.dart';
import 'package:fish_redux/fish_redux.dart';
import '../action.dart';
import 'action.dart';
import 'state.dart';

Effect<PaoBaState> buildEffect() {
  return combineEffects(<Object, Effect<PaoBaState>>{
    PaoBaAction.onAttentionUser: _onAttentionUser,
    PaoBaAction.onCancelAttentionUser: _onCancelAttentionUser
  });
}

//关注用户
void _onAttentionUser(Action action, Context<PaoBaState> ctx) async {
  var resp =
      await net.request(Routers.USER_WATCH, args: {"id": action.payload});
  if (resp.code == 200) {
    ctx.dispatch(
        MainSearchActionCreator.changeUserAttention(action.payload, true));
  }
}

//取消关注用户
void _onCancelAttentionUser(Action action, Context<PaoBaState> ctx) async {
  var resp =
      await net.request(Routers.USER_UNDO_WATCH, args: {"id": action.payload});
  if (resp.code == 200) {
    ctx.dispatch(
        MainSearchActionCreator.changeUserAttention(action.payload, false));
  }
}
