import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoRecordPage extends Page<VideoRecordState, Map<String, dynamic>> {
  VideoRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<VideoRecordState>(
                adapter: null,
                slots: <String, Dependent<VideoRecordState>>{
                }),
            middleware: <Middleware<VideoRecordState>>[
            ],);

}
