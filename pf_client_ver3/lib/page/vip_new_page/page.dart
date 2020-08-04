import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VipNewPage extends Page<VipNewState, Map<String, dynamic>> {
  VipNewPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<VipNewState>(
                adapter: null,
                slots: <String, Dependent<VipNewState>>{
                }),
            middleware: <Middleware<VipNewState>>[
            ],);

}
