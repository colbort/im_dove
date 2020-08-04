import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/storage/index.dart';
import 'action.dart';
import 'state.dart';

Reducer<PromotionState> buildReducer() {
  return asReducer(
    <Object, Reducer<PromotionState>>{
      PromotionAction.action: _onAction,
      PromotionAction.getShareContent: _getShareContent,
    },
  );
}

PromotionState _onAction(PromotionState state, Action action) {
  final PromotionState newState = state.clone();
  return newState;
}

PromotionState _getShareContent(PromotionState state, Action action) {
  final PromotionState newState = state.clone();
  var data = action.payload;
  var k1 = "url";
  var k2 = "inviteCode";
  if (data.containsKey(k1)) {
    newState.url = data[k1];
  }
  if (data.containsKey(k1)) {
    newState.inviteCode = data[k2];
  }
  ls.save(StorageKeys.SHARE_DATA, jsonTo(data));
  return newState;
}
