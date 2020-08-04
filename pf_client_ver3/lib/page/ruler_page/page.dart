import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RulerPage extends Page<RulerState, Map<String, dynamic>> {
  RulerPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<RulerState>(
                adapter: null,
                slots: <String, Dependent<RulerState>>{
                }),
            middleware: <Middleware<RulerState>>[
            ],);

}
