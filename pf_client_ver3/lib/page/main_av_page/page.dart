import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class MainAvPage extends Page<MainAvState, Map<String, dynamic>> {
  MainAvPage()
      : super(
          initState: initState,
          view: buildView,
          dependencies: Dependencies<MainAvState>(
              adapter: null, slots: <String, Dependent<MainAvState>>{}),
          middleware: <Middleware<MainAvState>>[],
        );
}
