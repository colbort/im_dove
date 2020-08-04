import 'package:app/storage/movie_cache.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoRecordState> buildEffect() {
  return combineEffects(<Object, Effect<VideoRecordState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<VideoRecordState> ctx) async {
  var data = await viewRecord.getMovieList();
  ctx.dispatch(VideoRecordActionCreator.onUpdate(data));
  ctx.state.subscription = viewRecord.update.listen((data) async {
    var data = await viewRecord.getMovieList();
    ctx.dispatch(VideoRecordActionCreator.onUpdate(data));
  });
}

void _onDispose(Action action, Context<VideoRecordState> ctx) {
  if (ctx.state.subscription != null) {
    ctx.state.subscription.cancel();
  }
}
