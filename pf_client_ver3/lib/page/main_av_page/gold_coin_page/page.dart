import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GoldCoinPage extends Page<GoldCoinState, Map<String, dynamic>> {
  GoldCoinPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GoldCoinState>(
                adapter: null,
                slots: <String, Dependent<GoldCoinState>>{
                }),
            middleware: <Middleware<GoldCoinState>>[
            ],);

}
