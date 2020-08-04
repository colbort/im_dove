import 'package:app/utils/logger.dart';
import 'package:video_player/video_player.dart';

enum CustomVideoControllerType {
  none,
  dispose,
  //已经调用了initialize方法
  initialized,
}

///播放器控制器
class CustomVideoController extends VideoPlayerController {
  var stype = CustomVideoControllerType.none;
  int initStartTime = 0;
  int initEndTime = 0;
  String customDataSource = "";
  CustomVideoController.network(String dataSource,
      {formatHint: VideoFormat.hls})
      : this.customDataSource = dataSource,
        super.network(dataSource, formatHint: formatHint);
  int playedSeconds = 0;
  int totalSeconds = 0;
  bool isBuffing = false;
  Function errCallback;
  bool _isCalledErr = false;
  bool isFullScreen = false;

  ///刷新control回调,
  Function(CustomVideoController) freshCallback;

  //用来做同步回调
  Function(CustomVideoController) updateCallback;

  ///初始化之后加上监听
  listener() {
    if (this.value.position.inSeconds > 0) {
      playedSeconds = this.value.position.inSeconds;
      if (totalSeconds == 0) {
        totalSeconds = this.value.duration.inSeconds;
      }
    }

    if (this.value.hasError) {
      if (!_isCalledErr) {
        _isCalledErr = true;
        log.i("play err: init" + this.value.initialized.toString());
        if (errCallback != null && errCallback is Function) {
          errCallback();
        }
      }
    } else {
      if (this.updateCallback != null) {
        this.updateCallback(this);
      }
      _checkBuffing();
    }
  }

  _checkBuffing() {
    if (this.value != null &&
        this.value.position != null &&
        this.value.buffered != null &&
        this.value.buffered.length > 0 &&
        this.value.isPlaying) {
      var isInBuffer = false;
      var nowSecodes = this.value.position.inSeconds;
      for (int i = 0; i < this.value.buffered.length; i++) {
        if (nowSecodes >= this.value.buffered[i].start.inSeconds &&
            nowSecodes < this.value.buffered[i].end.inSeconds) {
          isInBuffer = true;
          break;
        }
      }
      if (!isInBuffer) {
        if (!isBuffing) {
          if (this.freshCallback != null) {
            this.freshCallback(this);
          }
        }
        isBuffing = true;
      } else {
        if (isBuffing) {
          if (this.freshCallback != null) {
            this.freshCallback(this);
          }
        }
        isBuffing = false;
      }
    }
  }

  @override
  Future<void> initialize() async {
    this.stype = CustomVideoControllerType.initialized;
    return super.initialize();
  }

  @override
  Future<void> dispose() async {
    if (this.stype != CustomVideoControllerType.dispose) {
      log.i("释放:" + this.customDataSource);
      this.stype = CustomVideoControllerType.dispose;
      super.dispose();
    }
  }
}
