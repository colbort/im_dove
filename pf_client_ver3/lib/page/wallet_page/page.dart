import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WalletPage extends Page<WalletState, Map<String, dynamic>> {
  WalletPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WalletState>(
              adapter: null, slots: <String, Dependent<WalletState>>{}),
          middleware: <Middleware<WalletState>>[],
        );
}
