import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CollectionsPage extends Page<CollectionsState, Map<String, dynamic>> {
  CollectionsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CollectionsState>(
                adapter: null,
                slots: <String, Dependent<CollectionsState>>{
                }),
            middleware: <Middleware<CollectionsState>>[
            ],);

}
