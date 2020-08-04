import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoInfoComponent extends Component<VideoInfoState> {
  VideoInfoComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          shouldUpdate: _shouldUpdate,
          dependencies: Dependencies<VideoInfoState>(
              adapter: null, slots: <String, Dependent<VideoInfoState>>{}),
        );
}

bool _shouldUpdate(VideoInfoState old, VideoInfoState now) {
  return (old.videoId != now.videoId ||
      old.videoTitle != now.videoTitle ||
      old.videoWatch != now.videoWatch ||
      old.likes != now.likes ||
      old.unlikes != now.unlikes ||
      old.isFavorite != now.isFavorite ||
      old.canWatch != now.canWatch ||
      !listEquals(old.recommendVideoList, now.recommendVideoList) ||
      !listEquals(old.adModels, now.adModels));
}
