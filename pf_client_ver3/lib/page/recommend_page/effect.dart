import 'package:app/lang/lang.dart';
import 'package:app/page/main_page/action.dart';
import 'package:app/page/recommend_page/state.dart';
import 'package:app/utils/preview_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

TabController recommendTabController;
// 顶部标题
final List recommandTitles = [
  Lang.RECOMMAND_GUANFANG,
  Lang.RECOMMAND_PAOYOU,
  Lang.RECOMMAND_BANGDAN,
];

Effect<RecommendPageState> buildEffect() {
  return combineEffects(<Object, Effect<RecommendPageState>>{
    Lifecycle.initState: _onInit,
    MainAction.onSwitchIndex: _onSwitchMainPageIndex,
  });
}

void _onInit(Action action, Context<RecommendPageState> ctx) {
  if (null == recommendTabController) {
    final tickerProvider = ctx.stfState as TickerProvider;
    recommendTabController =
        TabController(vsync: tickerProvider, length: recommandTitles.length);
    recommendTabController.addListener(() {
      previewModule.recommendPageIndex = recommendTabController.index;
    });
  }
}

void _onSwitchMainPageIndex(Action action, Context<RecommendPageState> ctx) {
  var index = action.payload;
  previewModule.setEnable(index == 0);
  if (index == 0) {
    previewModule.beginAutoPlayIfNeed();
  }
}
