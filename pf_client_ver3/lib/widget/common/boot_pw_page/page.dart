import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';
import 'pw_point_component/component.dart';
import 'pw_key_board_component/component.dart';

class BootPwPage extends Page<BootPwState, Map<String, dynamic>> {
  BootPwPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BootPwState>(
              adapter: null,
              slots: <String, Dependent<BootPwState>>{
                'pwPoint': RwPointConnector() + PwPointComponent(),
                'pwKeyBoard': PwKeyBoardConnector() + PwKeyBoardComponent(),
              }),
          middleware: <Middleware<BootPwState>>[],
        );
}
