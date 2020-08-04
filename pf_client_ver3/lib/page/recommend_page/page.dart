import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RecommendPage extends Page<RecommendPageState, Map<String, dynamic>> {
  RecommendPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RecommendPageState>(
              adapter: null, slots: <String, Dependent<RecommendPageState>>{}),
          middleware: <Middleware<RecommendPageState>>[],
        );

  @override
  ComponentState<RecommendPageState> createState() => RecommendPageStateStf();
}
