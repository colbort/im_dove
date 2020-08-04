import 'package:fish_redux/fish_redux.dart';

class UploadNoticeState implements Cloneable<UploadNoticeState> {

  @override
  UploadNoticeState clone() {
    return UploadNoticeState();
  }
}

UploadNoticeState initState(Map<String, dynamic> args) {
  return UploadNoticeState();
}
