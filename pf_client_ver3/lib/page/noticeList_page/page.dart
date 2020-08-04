import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';
import './notice_adapter/adapter.dart';
class NoticeListPage extends Page<NoticeListState, Map<String, dynamic>> {
  NoticeListPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NoticeListState>(
                adapter: NoneConn<NoticeListState>() + NoticeAdapter(),
            ));
           

}
