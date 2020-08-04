import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EditPersonPage extends Page<EditPersonState, Map<String, dynamic>> {
  EditPersonPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EditPersonState>(
                adapter: null,
                slots: <String, Dependent<EditPersonState>>{
                }),
            middleware: <Middleware<EditPersonState>>[
            ],);

}
