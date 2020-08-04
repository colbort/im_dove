import 'package:app/page/main_pao_page/widget/main_pao_comment_list_component/component.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/component.dart';
import 'package:app/utils/comm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoMinePage extends Page<MainPaoMineState, Map<String, dynamic>> {
  MainPaoMinePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoMineState>(
              adapter: null,
              slots: <String, Dependent<MainPaoMineState>>{
                // componentList: MainPaoMineConnector() + MainPaoListComponent(),
                componentList:
                    PaoMinePostListConnector() + MainPaoListComponent(),
                componentList + "_buy":
                    PaoMineBuyListConnector() + MainPaoListComponent(),
                mainPaoCommentList:
                    PaoMineCommentConnector() + MainPaoCommentListComponent(),
              }),
          middleware: <Middleware<MainPaoMineState>>[],
        );
  @override
  ComponentState<MainPaoMineState> createState() {
    return MainPaoMinePageStf();
  }
}

class MainPaoMinePageStf extends ComponentState<MainPaoMineState>
    with SingleTickerProviderStateMixin {}
