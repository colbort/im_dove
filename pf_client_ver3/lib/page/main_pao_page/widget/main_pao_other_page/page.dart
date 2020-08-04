import 'package:app/page/main_pao_page/widget/main_pao_comment_list_component/component.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/component.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoOtherPage extends Page<MainPaoOtherState, Map<String, dynamic>> {
  MainPaoOtherPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoOtherState>(
              adapter: null,
              slots: <String, Dependent<MainPaoOtherState>>{
                componentList:
                    PaoMinePostListConnector() + MainPaoListComponent(),
                componentList + "_buy":
                    PaoMineBuyListConnector() + MainPaoListComponent(),
                mainPaoCommentList:
                    PaoMineCommentConnector() + MainPaoCommentListComponent(),
              }),
          middleware: <Middleware<MainPaoOtherState>>[],
        );
}
