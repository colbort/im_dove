import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../lang/lang.dart';
import 'model/pao_user_data_model.dart';
import 'widget/main_pao_item_component/state.dart';

class MainPaoState implements Cloneable<MainPaoState> {
  /// 关注列表
  List<MainPaoItemState> attentionList = [];

  /// 最新的
  List<MainPaoItemState> newestList = [];

  /// 最热的
  List<MainPaoItemState> hottestList = [];

  /// 精选
  List<MainPaoItemState> featuredList = [];

  /// 默认类型
  int stype = 1;

  /// 泡吧 用户数据
  PaoUserDataModel paoUserDataModel;

  @override
  MainPaoState clone() {
    return MainPaoState()
      ..attentionList = attentionList
      ..newestList = newestList
      ..hottestList = hottestList
      ..featuredList = featuredList
      ..paoUserDataModel = paoUserDataModel
      ..stype = stype;
  }

  /// 添加数据
  void addData(int no, List<MainPaoItemState> d) {
    if (no == 0) {
      if (attentionList == null) attentionList = [];
      attentionList.addAll(d);
    } else if (no == 1) {
      if (newestList == null) newestList = [];
      newestList.addAll(d);
    } else if (no == 2) {
      if (hottestList == null) hottestList = [];
      hottestList.addAll(d);
    } else if (no == 3) {
      if (featuredList == null) featuredList = [];
      featuredList.addAll(d);
    }
  }
}

MainPaoState initState(Map<String, dynamic> args) {
  var d = MainPaoState();
  // createData(0, d);
  // createData(1, d);
  // createData(2, d);
  // createData(3, d);
  return d;
}

/// 泡吧 tab类型
class MainPaoTabType {
  int stype;
  String name;
  bool bSelected;
  MainPaoTabType(this.stype, this.name, this.bSelected);
}

/// tabbar
TabController tabController;

/// tablist
final List<MainPaoTabType> tabList = [
  MainPaoTabType(0, Lang.GUANZHU, false),
  MainPaoTabType(1, Lang.ZUIXIN, true),
  MainPaoTabType(2, Lang.ZUIRE, false),
  MainPaoTabType(3, Lang.JINGXUAN, false),
  MainPaoTabType(4, Lang.WODE, false),
];
