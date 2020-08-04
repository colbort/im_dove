import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef OnRefresh = void Function();
typedef OnLoading = void Function();

Widget pullRefresh({
  Widget child,
  OnRefresh onRefresh,
  OnLoading onLoading,
  RefreshController refreshController,
  bool enablePullDown = true,
  bool enablePullUp = true,
}) {
  return SmartRefresher(
    enablePullDown: enablePullDown,
    enablePullUp: enablePullUp,
    header: WaterDropHeader(
      complete: const Text(
        Lang.SHUAXINWANCHENG,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    ),
    footer: ClassicFooter(
        loadingText: Lang.JIAZAIZHONG,
        canLoadingText: Lang.SONGKAIJIAZAIGENGDUO,
        noDataText: Lang.MEIYOUGENGDUOSHUJU,
        idleText: Lang.SHANGLAJIAZAIGENGDUO,
        textStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal)),
    controller: refreshController,
    onRefresh: () {
      vibrate();
      if (null != onRefresh) onRefresh();
    },
    onLoading: () {
      vibrate();
      if (null != onLoading) onLoading();
    },
    child: child,
  );
}
