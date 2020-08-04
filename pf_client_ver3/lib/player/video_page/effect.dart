import 'dart:io';

import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/wallet_page/effect.dart';
import 'package:app/player/preview_player/preview_player_ctrl.dart';
import 'package:app/player/video_page/video_component/action.dart';
import 'package:app/player/video_page/video_info_component/action.dart';
import 'package:app/storage/movie_cache.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/utils/native.dart';
import 'package:app/player/video_page/video_element.dart' as videoElement;

Effect<VideoState> buildEffect() {
  return combineEffects(<Object, Effect<VideoState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _onDispose,
    VideoAction.onBuyVideo: _onBuyVideo,
  });
}

double systemBrightness = 0.0;
void _initState(Action action, Context<VideoState> ctx) async {
  systemBrightness = await n.getSystemBrightness();
  //视频播放器加载前释放到预览播放器
  WidgetsBinding.instance.addPostFrameCallback((_) {
    disposeCurCtrl();
  });
  Wakelock.enable();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ctx.dispatch(VideoInfoActionCreator.onGetVideoInfo(ctx.state.videoId));
  });
}

void _onDispose(Action action, Context<VideoState> ctx) {
  if (videoElement.controller != null &&
      videoElement.controller.totalSeconds > 0) {
    viewRecord.saveMovie(
        ctx.state.infoState.videoId.toString(),
        ctx.state.infoState.videoTitle,
        ctx.state.infoState.coverUrl,
        videoElement.controller.playedSeconds,
        videoElement.controller.totalSeconds,
        false);
  }

  Wakelock.disable();
  if (Platform.operatingSystem != "ios") {
    n.resetBrightness();
  } else {
    n.setSystemBrightness(systemBrightness);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future<void> _onBuyVideo(Action action, Context<VideoState> ctx) async {
  var id = action.payload;
  if (id <= 0) return;
  var resp1 = await _buyVideoNet(id);
  var str = resp1.code == 200 ? Lang.BUYSUCC : Lang.BUYFAIL;
  var type = resp1.code == 200 ? ToastType.positive : ToastType.negative;
  showToast(str, type: type);
  if (resp1.code == 200) {
    ctx.dispatch(VideoActionCreator.closeVideoDialogAction());
    ctx.dispatch(VideoComActionCreator.onFreshCanWatchAction(true));
    ctx.dispatch(VideoInfoActionCreator.onFreshCanWatch(true));
    ctx.dispatch(VideoComActionCreator.onFreshUpdateCallBack(null));
    sendWalletNet();
  }
}

/// 余额购买
Future _buyVideoNet(int id) async {
  var resp =
      await net.request(Routers.VIP_BUYVIDEO_POST, args: {"videoId": id});
  return resp;
}
