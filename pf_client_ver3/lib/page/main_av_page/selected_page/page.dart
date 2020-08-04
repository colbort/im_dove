import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SelectedPage extends Page<SelectedState, Map<String, dynamic>> {
  SelectedPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SelectedState>(
                adapter: null,
                slots: <String, Dependent<SelectedState>>{
                }),
            middleware: <Middleware<SelectedState>>[
            ],);

}
