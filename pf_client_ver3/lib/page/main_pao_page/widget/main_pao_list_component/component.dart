import 'package:app/page/main_pao_page/widget/main_pao_adapter/adapter.dart';
import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoListComponent extends Component<MainPaoListState> {
  MainPaoListComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MainPaoListState>(
              adapter: NoneConn<MainPaoListState>() + MainPaoAdapter(),
              slots: <String, Dependent<MainPaoListState>>{}),
        );
}
