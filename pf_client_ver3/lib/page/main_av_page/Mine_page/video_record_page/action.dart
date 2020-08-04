import 'package:app/pojo/av_data.dart';
import 'package:fish_redux/fish_redux.dart';

enum VideoRecordAction {
  update,
}

class VideoRecordActionCreator {
  static Action onUpdate(ViewRecordsBean bean) {
    return Action(VideoRecordAction.update, payload: bean);
  }
}
