import 'package:app/page/main_mine_page/models/mine_model.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

Effect<EditPersonState> buildEffect() {
  return combineEffects(<Object, Effect<EditPersonState>>{
    EditPersonAction.onGetInfo: _onGetInfo,
  });
}

void _onGetInfo(Action action, Context<EditPersonState> ctx) async {
  final resp = await net.request(Routers.USER_BASE_GET, method: 'get');
  if (resp.code == 200) {
    ctx.dispatch(EditPersonActionCreator.onSaveInfoAction(resp.data));
    var data = MineModel.fromJson(resp.data);
    saveMineModel(data);
  }
}
