import 'package:flutter/cupertino.dart';

final PreviewModule previewModule = PreviewModule();

class PreviewModule with ChangeNotifier {
  int recommendPageIndex = 0;
  int lastPlayIndex = 0;

  /// 是否允许自动播放，更具index==0判断是否在推荐页面
  bool _enableAutoPlay = true;

  /// 是否允许下一次自动刷新播放
  void beginAutoPlayIfNeed() {
    notifyListeners();
  }

  setEnable(bool enable) {
    _enableAutoPlay = enable;
  }

  bool get enable => _enableAutoPlay;
}
