import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoComponent extends Component<VideoComState> {
  VideoComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          shouldUpdate: _shouldUpdate,
          dependencies: Dependencies<VideoComState>(
              adapter: null, slots: <String, Dependent<VideoComState>>{}),
        );
}

bool _shouldUpdate(VideoComState old, VideoComState now) {
  return (old.videoUrl != now.videoUrl ||
      old.updateCallBack != now.updateCallBack ||
      old.isShowVideoTopUi != now.isShowVideoTopUi);
}
