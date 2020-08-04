import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainMinePage extends Page<MainMineState, Map<String, dynamic>> {
  MainMinePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MainMineState>(
                adapter: null,
                slots: <String, Dependent<MainMineState>>{
                }),
            middleware: <Middleware<MainMineState>>[
            ],);

}
