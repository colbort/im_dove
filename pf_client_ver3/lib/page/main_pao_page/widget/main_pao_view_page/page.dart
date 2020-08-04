import 'package:app/page/main_pao_page/widget/main_pao_list_component/component.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoViewPage extends Page<MainPaoViewState, Map<String, dynamic>> {
  MainPaoViewPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoViewState>(
              adapter: null,
              slots: <String, Dependent<MainPaoViewState>>{
                componentList: MainPaoViewConnector() + MainPaoListComponent(),
              }),
          middleware: <Middleware<MainPaoViewState>>[],
        );
}
