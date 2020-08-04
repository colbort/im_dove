import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoDetailPage extends Page<MainPaoDetailState, Map<String, dynamic>> {
  MainPaoDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoDetailState>(
              adapter: null, slots: <String, Dependent<MainPaoDetailState>>{}),
          middleware: <Middleware<MainPaoDetailState>>[],
        );
}
