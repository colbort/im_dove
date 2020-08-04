import 'dart:async';
import 'cache.dart';
import 'video_queue.dart';
import 'package:app/loc_server/loc_server.dart';
// import 'package:app/utils/logger.dart';

Timer _timer;
startCacheTask() {
  _timer?.cancel();
  _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
    // log.i('server.connectionsInfo().active:' +
    //     server.connectionsInfo().active.toString() +
    //     " videoPlayingIdx:" +
    //     videoPlayingIdx.toString());
    //sever正常运行，且是否空闲
    if (server == null || server.connectionsInfo().active > 0) {
      return;
    }
    // log.i('isCaching:' +
    //     isCaching.toString() +
    //     " videoList.length:" +
    //     videoList.length.toString());
    //cache是否处于空闲状态
    if (isCaching || videoList.length == 0) {
      return;
    }

    cacheNextVideoElement();
  });
}

///这里停掉缓存任务的同时，也会清除缓存队列信息，如果不需要清除缓存信息，到时候再写接口
stopCacheTask() {
  _timer?.cancel();
  resetVideoElements();
}
