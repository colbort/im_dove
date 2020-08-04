import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NvDetailPage extends Page<NvDetailState, Map<String, dynamic>> {
  NvDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          middleware: <Middleware<NvDetailState>>[],
        );
}
