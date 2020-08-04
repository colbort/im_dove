import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UploadNoticePage extends Page<UploadNoticeState, Map<String, dynamic>> {
  UploadNoticePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UploadNoticeState>(
                adapter: null,
                slots: <String, Dependent<UploadNoticeState>>{
                }),
            middleware: <Middleware<UploadNoticeState>>[
            ],);

}
