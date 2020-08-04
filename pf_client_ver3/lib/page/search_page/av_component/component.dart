import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AvComponent extends Component<AvState> {
  AvComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AvState>(
                adapter: null,
                slots: <String, Dependent<AvState>>{
                }),);

}
