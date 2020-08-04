import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoPlayPage extends Page<MainPaoPlayState, Map<String, dynamic>> {
  MainPaoPlayPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MainPaoPlayState>(
                adapter: null,
                slots: <String, Dependent<MainPaoPlayState>>{
                }),
            middleware: <Middleware<MainPaoPlayState>>[
            ],);

}
