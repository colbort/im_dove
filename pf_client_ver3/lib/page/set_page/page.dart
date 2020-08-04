import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SetPage extends Page<SetPageState, Map<String, dynamic>> with RouteAware {
  SetPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SetPageState>(
                adapter: null,
                slots: <String, Dependent<SetPageState>>{
                }),
            middleware: <Middleware<SetPageState>>[
            ],);

}
