import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoPage extends Page<MainPaoState, Map<String, dynamic>> {
  MainPaoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoState>(
              adapter: null, slots: <String, Dependent<MainPaoState>>{}),
          middleware: <Middleware<MainPaoState>>[],
        );
}
