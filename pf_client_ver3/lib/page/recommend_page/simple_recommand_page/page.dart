import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SimpleRecommandPage extends Page<SimpleRecommandState, int> {
  SimpleRecommandPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SimpleRecommandState>(
              adapter: null,
              slots: <String, Dependent<SimpleRecommandState>>{}),
          middleware: <Middleware<SimpleRecommandState>>[],
        );
}
