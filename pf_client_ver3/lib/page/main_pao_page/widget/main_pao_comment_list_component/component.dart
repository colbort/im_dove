import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPaoCommentListComponent extends Component<MainPaoCommentListState> {
  MainPaoCommentListComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MainPaoCommentListState>(
                adapter: null,
                slots: <String, Dependent<MainPaoCommentListState>>{
                }),);

}
