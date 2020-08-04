import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<NvDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<NvDetailState>>{
      NvDetailAction.saveActorsDetail: _saveActorsDetail,
    },
  );
}

NvDetailState _saveActorsDetail(NvDetailState state, Action action) {
  final NvDetailState newState = state.clone();
  var _data = action.payload;
  newState.otherData = {
    'domain': _data['domain'],
    'actorsName': _data['actorsName'],
    'actorsPhoto': _data['actorsPhoto'],
    'actorIntroduction': _data['actorIntroduction'],
  };
  newState.actorVideos.addAll(_data['videos']);
  newState.isInit = false;
  return newState;
}
