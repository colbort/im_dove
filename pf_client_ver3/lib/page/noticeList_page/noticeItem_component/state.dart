import 'package:fish_redux/fish_redux.dart';

class NoticeItemState implements Cloneable<NoticeItemState> {
  String name;
  String content;
  String createdAt;
  NoticeItemState({this.name, this.content, this.createdAt});

  @override
  NoticeItemState clone() {
    return NoticeItemState()
            ..name = name
            ..createdAt = createdAt
            ..content = content;

  }
}

NoticeItemState initState(Map<String, dynamic> args) {
  return NoticeItemState()
          ..name = ''
          ..createdAt = ''
          ..content = '';
}
