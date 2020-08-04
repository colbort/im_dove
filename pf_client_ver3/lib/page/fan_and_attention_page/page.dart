import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FanAndAttentionPage
    extends Page<FanAndAttentionState, Map<String, dynamic>> {
  @override
  FanAndAttentionStf createState() => FanAndAttentionStf();
  FanAndAttentionPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FanAndAttentionState>(
              adapter: null,
              slots: <String, Dependent<FanAndAttentionState>>{}),
          middleware: <Middleware<FanAndAttentionState>>[],
        );
}

class FanAndAttentionStf extends ComponentState<FanAndAttentionState>
    with SingleTickerProviderStateMixin {}
