import 'package:fish_redux/fish_redux.dart';

enum PromotionAction {
  action,

  /// 获取推广数据
  onGetShareContent,

  /// 获取推广数据
  getShareContent,

  /// 复制链接
  onCopyClick,

  /// 保存图片
  onSavePicClick,
}

class PromotionActionCreator {
  static Action onAction() {
    return const Action(PromotionAction.action);
  }

  /// 获取推广数据
  static Action onGetShareContent() {
    return const Action(PromotionAction.onGetShareContent);
  }

  /// 获取推广数据
  static Action getShareContent(Map<String, dynamic> data) {
    return Action(PromotionAction.getShareContent, payload: data);
  }

  /// 复制链接
  static Action onCopyClick() {
    return const Action(PromotionAction.onCopyClick);
  }

  /// 保存图片
  static Action onSavePicClick() {
    return const Action(PromotionAction.onSavePicClick);
  }
}
