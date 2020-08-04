import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FemaleListPage extends Page<FemaleListPageState, Map<String, dynamic>> {
  FemaleListPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<FemaleListPageState>(
                adapter: null,
                slots: <String, Dependent<FemaleListPageState>>{
                }),
            middleware: <Middleware<FemaleListPageState>>[
            ],);

}
