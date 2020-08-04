import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AlichargePage extends Page<AlichargeState, Map<String, dynamic>> {
  AlichargePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AlichargeState>(
                adapter: null,
                slots: <String, Dependent<AlichargeState>>{
                }),
            middleware: <Middleware<AlichargeState>>[
            ],);

}
