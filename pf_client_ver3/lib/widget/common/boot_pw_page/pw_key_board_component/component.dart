import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';

class PwKeyBoardComponent extends Component<PwKeyBoardState> {
  PwKeyBoardComponent()
      : super(
          effect: buildEffect(),
          view: buildView,
          dependencies: Dependencies<PwKeyBoardState>(
              adapter: null, slots: <String, Dependent<PwKeyBoardState>>{}),
        );
}
