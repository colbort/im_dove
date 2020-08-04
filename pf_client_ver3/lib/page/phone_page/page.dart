import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PhonePage extends Page<PhoneState, Map<String, dynamic>> {
  PhonePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PhoneState>(
                adapter: null,
                slots: <String, Dependent<PhoneState>>{
                }),
            middleware: <Middleware<PhoneState>>[
            ],);

}
