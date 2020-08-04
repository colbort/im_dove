import 'package:app/page/main_mine_page/models/mine_model.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'action.dart';
import 'state.dart';

Effect<EditImgState> buildEffect() {
  return combineEffects(<Object, Effect<EditImgState>>{
    EditImgAction.onGetInfo: _onGetInfo,
  });
}

void _onGetInfo(Action action, Context<EditImgState> ctx) async {
  final resp = await net.request(Routers.USER_BASE_GET, method: 'get');
  if (resp.code == 200) {
    ctx.dispatch(EditImgActionCreator.onSaveInfoAction(resp.data));
    var data = MineModel.fromJson(resp.data);
    saveMineModel(data);
  }
}
