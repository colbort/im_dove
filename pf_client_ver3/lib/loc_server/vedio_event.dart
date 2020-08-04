import 'package:event_bus/event_bus.dart';

/// 视频跳转事件类
class PlayerSeektoEvent {
  Duration duration;
  PlayerSeektoEvent(this.duration);
}

/// 视频消息总线
EventBus videoEventBus;

EventBus videoCurTimeFreshBus;

eventInit() {
  videoEventBus = EventBus();
  videoCurTimeFreshBus = EventBus();

  videoEventBus.on<PlayerSeektoEvent>().listen((event) {
    // var ms = event.duration.inMilliseconds;
    // debugPrint("拖动到多少ms：" + ms.toString());
    // catchCurrentTsFrame(ms);
    // if (catchingCurTsFrameName == null || catchingCurTsFrameName.isEmpty) {
    //   return;
    // }
    // debugPrint("catchingCurTsFrameName:" + catchingCurTsFrameName);
    // debugPrint("currentTsFrame:" + currentTsFrame);
    // if (isNeedDrop(currentTsFrame)) {
    //   cancelCurDownloadAndDrop();
    // }
  });

  videoCurTimeFreshBus.on<PlayerSeektoEvent>().listen((event) {
    // var ms = event.duration.inMilliseconds;
    // // debugPrint("更新到多少ms：" + ms.toString());
    // freshCurrentTsFrame(ms);
  });
}
