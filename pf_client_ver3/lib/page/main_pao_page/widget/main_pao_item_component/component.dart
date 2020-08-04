import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoItemComponent extends Component<MainPaoItemState> {
  MainPaoItemComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoItemState>(
              adapter: null, slots: <String, Dependent<MainPaoItemState>>{}),
        );
}
