import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NoticeItemComponent extends Component<NoticeItemState> {
  NoticeItemComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            );

}
