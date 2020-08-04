import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<MainMineState> buildReducer() {
  return asReducer(
    <Object, Reducer<MainMineState>>{
      MainMineAction.saveInfo: _onSaveInfo,
      MainMineAction.changePwChecked: _onChangePwChecked,
      MainMineAction.saveVersion: _onSaveVersion,
      MainMineAction.saveImageCache: _onSaveImageChche,
      MainMineAction.changePhone: _onChangePhone
    },
  );
}

MainMineState _onSaveInfo(MainMineState state, Action action) {
  final MainMineState newState = state.clone();
  newState.shortWatchRemain = action.payload['shortWatchRemain'];
  newState.avWatchRemain = action.payload['avWatchRemain'];
  newState.totalWatch = action.payload['totalWatch'];
  newState.remainDownload = action.payload['remainDownload'];
  newState.promotion = action.payload['promotion'];
  newState.vipExpireDate = action.payload['vipExpireDate'];
  newState.promotionExpireDate = action.payload['promotionExpireDate'];
  newState.logo = action.payload['logo'];
  newState.mobile = action.payload['mobile'];
  newState.nickName = action.payload['nickName'];
  newState.gender = action.payload['gender'];
  newState.chatURL = action.payload['chatURL'];
  newState.inviteCode = action.payload['inviteCode'];
  newState.level = action.payload['level'];
  newState.isSetPayCode = action.payload['isSetPayCode'];
  newState.showAgent = action.payload['showAgent'];
  saveVipInfo(newState.vipExpireDate, newState.promotionExpireDate);
  return newState;
}

MainMineState _onChangePwChecked(MainMineState state, Action action) {
  final MainMineState newState = state.clone();
  newState.pwChecked = action.payload;
  return newState;
}

MainMineState _onChangePhone(MainMineState state, Action action) {
  final MainMineState newState = state.clone();
  newState.mobile = action.payload;
  return newState;
}

MainMineState _onSaveVersion(MainMineState state, Action action) {
  final MainMineState newState = state.clone();
  newState.version = action.payload;
  return newState;
}

MainMineState _onSaveImageChche(MainMineState state, Action action) {
  final MainMineState newState = state.clone();
  newState.imageCache = action.payload;
  return newState;
}
