import 'package:fish_redux/fish_redux.dart';

enum NoticeListAction { saveNoticeList, getNoticeList }

class NoticeListActionCreator {
  static Action saveNoticeList(List<dynamic> arr) {
    return Action(NoticeListAction.saveNoticeList, payload: arr);
  }

  static Action getNoticeList(Map<String, dynamic> params) {
    return Action(NoticeListAction.getNoticeList, payload: {'params': params});
  }
}
