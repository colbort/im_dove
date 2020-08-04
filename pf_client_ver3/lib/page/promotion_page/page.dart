import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PromotionPage extends Page<PromotionState, Map<String, dynamic>> {
  PromotionPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PromotionState>(
                adapter: null,
                slots: <String, Dependent<PromotionState>>{
                }),
            middleware: <Middleware<PromotionState>>[
            ],);

}
