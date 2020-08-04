import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

var eventBus = EventBus();
var appPausedEventBus = EventBus();

/// app 收到后台
var appUnFocusEventBus = EventBus();
var freshBootPageEventBus;

var reLoginEventBus = EventBus();
var mainPageInited = false;
var isHanderingRelogin = false;
var isResumed = false;

var isAlowedBackApp = EventBus();

var collectionEventBus = EventBus();

var spCommentsEventBus = EventBus();

class CollectionEvent {
  bool edit;
  CollectionEvent(this.edit);
}

// 用于评论刷新
class CommentRefreshEvent {
  int videoId;
  CommentRefreshEvent(this.videoId);
}

var commentRefreshEventBus = EventBus();

//用于加载更多评论
var loadMoreCommentBus = EventBus();

var statusBarEvent = EventBus();

///用于加载数据后的List同步
var loadCommentListBus = EventBus();
var loadSecondListBus = EventBus();

/// added by jianghe 主要用于全屏状态下android点击虚拟返回按钮的bug
var popEventBus = EventBus();

class PopEvent {
  BuildContext context;
  PopEvent(this.context);
}

// added by jianghe 主要用在评论列表滑动到最顶部可以进行拖拽关闭
var commentScrollEventBus = EventBus();

class ScrollEvent {
  bool isTop;
  ScrollEvent(this.isTop);
}

// added by jianghe 主要用在评论列表滑动到最顶部可以进行拖拽关闭
var commentScrollUpdateEventBus = EventBus();

class ScrollUpdateEvent {
  bool isUpdate;
  ScrollUpdateEvent(this.isUpdate);
}
