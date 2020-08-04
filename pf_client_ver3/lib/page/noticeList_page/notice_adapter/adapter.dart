import 'package:fish_redux/fish_redux.dart';

import 'reducer.dart';
import '../state.dart';
import '../noticeItem_component/component.dart';
import '../noticeItem_component/state.dart';

class NoticeAdapter extends DynamicFlowAdapter<NoticeListState> {
  NoticeAdapter()
      : super(
          pool: <String, Component<Object>>{
            'noticeItem': NoticeItemComponent()
          },
          connector: _NoticeConnector(),
          reducer: buildReducer(),
        );
}

class _NoticeConnector extends ConnOp<NoticeListState, List<ItemBean>>
    with ReselectMixin<NoticeListState, List<ItemBean>> {
  @override
  void set(NoticeListState state, List<ItemBean> items) {
    if (items?.isNotEmpty == true) {
      state.list = List<NoticeItemState>.from(
          items.map<NoticeItemState>((ItemBean bean) => bean.data).toList());
    } else {
      state.list = <NoticeItemState>[];
    }
  }

  @override
  List<ItemBean> computed(NoticeListState state) {
    if (state.list?.isNotEmpty == true) {
      return state.list
          .map<ItemBean>((dynamic data) => ItemBean('noticeItem', data))
          .toList();
    } else {
      return <ItemBean>[];
    }
  }

  @override
  List<dynamic> factors(NoticeListState state) {
    return [state.list];
  }
}
