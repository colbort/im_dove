import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CalssifyPage extends Page<CalssifyState, Map<String, dynamic>> {
  CalssifyPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CalssifyState>(
                adapter: null,
                slots: <String, Dependent<CalssifyState>>{
                }),
            middleware: <Middleware<CalssifyState>>[
            ],);

}
