import 'dart:io';

import 'package:app/player/preview_player/preview_player_ctrl.dart';
import 'package:app/utils/native.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:wakelock/wakelock.dart';
import 'action.dart';
import 'state.dart';

Effect<MainPaoPlayState> buildEffect() {
  return combineEffects(<Object, Effect<MainPaoPlayState>>{
    MainPaoPlayAction.action: _onAction,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<MainPaoPlayState> ctx) {}

double systemBrightness = 0.0;
void _initState(Action action, Context<MainPaoPlayState> ctx) async {
  systemBrightness = await n.getSystemBrightness();
  //视频播放器加载前释放到预览播放器
  WidgetsBinding.instance.addPostFrameCallback((_) {
    disposeCurCtrl();
  });
  Wakelock.enable();
}

void _onDispose(Action action, Context<MainPaoPlayState> ctx) {
  Wakelock.disable();
  if (Platform.operatingSystem != "ios") {
    n.resetBrightness();
  } else {
    n.setSystemBrightness(systemBrightness);
  }
}
