import 'package:fish_redux/fish_redux.dart';

enum MainAction {
  switchIndex,
  onSwitchIndex,

  setVideoState,

  /// 初始化视频模块
  onInitVideoPage,

  /// 专题模块
  onInitZTPage,

  /// 我的模块
  onInitMyHome,

  ///跳转到专题并切换专题分类
  onSwitchToTopic,

  ///显示右下角浮动广告banner
  // showFloatingButton,

  ///显示右下角浮动广告banner
  // onShowFloatingButton,

  onShowUpdater,

  ///是否显示全部浮动条
  // showFullFloatingActionButton,
  // onShowFullFloatingActionButton
}

class MainActionCreator {
  static Action onSwitchIndexAction(int index) {
    return Action(MainAction.onSwitchIndex, payload: index);
  }

  static Action switchIndexAction(int index) {
    return Action(MainAction.switchIndex, payload: index);
  }

  ///视频状态监控刷新
  static Action onSetVideoState(bool state) {
    return Action(MainAction.setVideoState, payload: state);
  }

  /// 初始化视频模块
  static Action onInitVideoPage() {
    return Action(MainAction.onInitVideoPage);
  }

  /// 专题模块
  static Action onInitZTPage() {
    return const Action(MainAction.onInitZTPage);
  }

  /// 我的模块
  static Action onInitMyHome() {
    return const Action(MainAction.onInitMyHome);
  }

  ///跳转到专题并切换专题分类
  static Action onSwitchToTopicAction(String data) {
    return Action(MainAction.onSwitchToTopic, payload: data);
  }

  ///显示右下角浮动广告banner
  // static Action showFloatingButtonAction(bool show) {
  //   return Action(MainAction.showFloatingButton, payload: show);
  // }

  ///显示右下角浮动广告banner
  // static Action onShowFloatingButtonAction(bool show) {
  //   return Action(MainAction.onShowFloatingButton, payload: show);
  // }

  static Action onShowUpdater(bool show) {
    return Action(MainAction.onShowUpdater, payload: show);
  }

  ///是否显示全部浮动条
  // static Action showFullFloatingActionButton(bool show) {
  //   return Action(MainAction.showFullFloatingActionButton, payload: show);
  // }

  // static Action onShowFullFloatingActionButton(bool show) {
  //   return Action(MainAction.onShowFullFloatingActionButton, payload: show);
  // }
}
