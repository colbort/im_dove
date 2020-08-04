import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UniverdalPage extends Page<UniversalPageState, Map<String, dynamic>> with RouteAware {
  UniverdalPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UniversalPageState>(
                adapter: null,
                slots: <String, Dependent<UniversalPageState>>{
                }),
            middleware: <Middleware<UniversalPageState>>[
            ],);

}
