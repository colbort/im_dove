import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_comment_list_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPaoOtherState implements Cloneable<MainPaoOtherState> {
  int userId = 0;
  String name = "";

  /// 用户数据
  PaoUserDataModel paoUserData;

  /// 我的帖子数据
  List<MainPaoItemState> myReleaseList = [];

  /// 我的收藏 购买数据
  List<MainPaoItemState> buyOrCollectList = [];

  /// 评论回复数据
  List<PaoCommentModel> commentList = [];

  /// 我的帖子刷新数据
  RefreshController myPostRefreshController = RefreshController();

  ///  我的评论刷新数据
  RefreshController myReplysRefreshController = RefreshController();

  /// 我的收藏购买刷新数据
  RefreshController myFav2BuyrefreshController = RefreshController();

  @override
  MainPaoOtherState clone() {
    return MainPaoOtherState()
      ..userId = userId
      ..name = name
      ..paoUserData = paoUserData
      ..myPostRefreshController = myPostRefreshController
      ..myReplysRefreshController = myReplysRefreshController
      ..myFav2BuyrefreshController = myFav2BuyrefreshController
      ..myReleaseList = myReleaseList
      ..buyOrCollectList = buyOrCollectList
      ..commentList = commentList;
  }
}

MainPaoOtherState initState(Map<String, dynamic> args) {
  if (args == null) return MainPaoOtherState();
  return MainPaoOtherState()
    ..userId = args["userId"]
    ..name = args["name"];
}

/// 我的帖子数据转换
class PaoMinePostListConnector
    extends ConnOp<MainPaoOtherState, MainPaoListState>
    with ReselectMixin<MainPaoOtherState, MainPaoListState> {
  @override
  MainPaoListState computed(MainPaoOtherState state) {
    return MainPaoListState()
      ..dataList = state.myReleaseList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoOtherState state) {
    return <dynamic>[...state.myReleaseList];
  }

  @override
  void set(MainPaoOtherState state, MainPaoListState subState) {
    state.myReleaseList = subState.dataList;
  }
}

/// 我的收藏购买 数据转换
class PaoMineBuyListConnector
    extends ConnOp<MainPaoOtherState, MainPaoListState>
    with ReselectMixin<MainPaoOtherState, MainPaoListState> {
  @override
  MainPaoListState computed(MainPaoOtherState state) {
    return MainPaoListState()
      ..dataList = state.buyOrCollectList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoOtherState state) {
    return <dynamic>[...state.buyOrCollectList];
  }

  @override
  void set(MainPaoOtherState state, MainPaoListState subState) {
    state.buyOrCollectList = subState.dataList;
  }
}

/// 我的评论 数据转换
class PaoMineCommentConnector
    extends ConnOp<MainPaoOtherState, MainPaoCommentListState>
    with ReselectMixin<MainPaoOtherState, MainPaoCommentListState> {
  @override
  MainPaoCommentListState computed(MainPaoOtherState state) {
    return MainPaoCommentListState()
      ..dataList = state.commentList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoOtherState state) {
    return <dynamic>[...state.commentList];
  }

  @override
  void set(MainPaoOtherState state, MainPaoCommentListState subState) {
    state.commentList = subState.dataList;
  }
}
