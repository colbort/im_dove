import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BootPage extends Page<BootState, Map<String, dynamic>> {
  BootPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BootState>(
              adapter: null, slots: <String, Dependent<BootState>>{}),
          middleware: <Middleware<BootState>>[],
        );
}
