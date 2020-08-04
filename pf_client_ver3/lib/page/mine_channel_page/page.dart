import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineChannelPage extends Page<MineChannelState, Map<String, dynamic>> {
  MineChannelPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MineChannelState>(
                adapter: null,
                slots: <String, Dependent<MineChannelState>>{
                }),
            middleware: <Middleware<MineChannelState>>[
            ],);

}
