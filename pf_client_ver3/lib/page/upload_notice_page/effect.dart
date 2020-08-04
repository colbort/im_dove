import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<UploadNoticeState> buildEffect() {
  return combineEffects(<Object, Effect<UploadNoticeState>>{
    UploadNoticeAction.action: _onAction,
  });
}

void _onAction(Action action, Context<UploadNoticeState> ctx) {
}
