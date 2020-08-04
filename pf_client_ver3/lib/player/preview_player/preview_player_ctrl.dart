import 'package:app/loc_server/vedio_data.dart';
import 'package:app/player/preview_player/preview_player.dart';

///全局播放器，用于预览视频；当av和原创播放的时候，要过来释放这个控制器
import 'package:app/player/video_player/custom_video_control.dart';
import 'package:app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

CustomVideoController curCtrl;

CustomVideoController getCtrl(String url) {
  var _tmpUrl = m3u8Remote2Local(url);
  //重复地址直接返回
  if (curCtrl != null &&
      curCtrl.stype != CustomVideoControllerType.dispose &&
      curCtrl.customDataSource == _tmpUrl) {
    log.i("相同地址播放器不需要释放:" + curCtrl.customDataSource);
    return curCtrl;
  }

  //释放上一个控制器
  if (curCtrl != null && curCtrl.stype != CustomVideoControllerType.dispose) {
    var lastCtrl = curCtrl;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log.i("释放老的播放器");
      lastCtrl?.dispose();
    });
  }

  var localUrl = preInitVideoPlay(url);
  curCtrl =
      CustomVideoController.network(localUrl, formatHint: VideoFormat.hls);

  return curCtrl;
}

//TODO 底部标签栏切换的时候，也需要释放掉当前视频播放控制器，可以放到主页的底部导航栏切换的时候处理；泡吧，首页顶部tabbar切换的时候，应该也需要进行这个操作

void disposeCurCtrl() {
  ctrlDisposeEvent.fire(true);
  if (curCtrl != null && curCtrl.stype != CustomVideoControllerType.dispose) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // log.i("手动释放预览播放器：" + curCtrl.customDataSource);
      curCtrl?.dispose();
      curCtrl = null;
    });
  }
}
