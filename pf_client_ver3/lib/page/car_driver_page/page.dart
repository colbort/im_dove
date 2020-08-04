import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CarDriverPage extends Page<CarDriverState, Map<String, dynamic>> {
  CarDriverPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CarDriverState>(
              adapter: null, slots: <String, Dependent<CarDriverState>>{}),
          middleware: <Middleware<CarDriverState>>[],
        );
}
