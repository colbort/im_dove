import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PurchasePage extends Page<PurchaseState, Map<String, dynamic>> {
  PurchasePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PurchaseState>(
                adapter: null,
                slots: <String, Dependent<PurchaseState>>{
                }),
            middleware: <Middleware<PurchaseState>>[
            ],);

}
