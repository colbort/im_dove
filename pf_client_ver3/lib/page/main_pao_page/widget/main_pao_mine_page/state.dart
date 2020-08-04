import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/page/main_pao_page/widget/main_pao_comment_list_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_item_component/state.dart';
import 'package:app/page/main_pao_page/widget/main_pao_list_component/state.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainPaoMineState implements Cloneable<MainPaoMineState> {
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

  // /// 我的帖子数据控制器
  // ScrollController myReleaseController = ScrollController();

  // /// 我的收藏购买数据控制器
  // ScrollController buyController = ScrollController();
  @override
  MainPaoMineState clone() {
    return MainPaoMineState()
      ..paoUserData = paoUserData
      ..myPostRefreshController = myPostRefreshController
      ..myReplysRefreshController = myReplysRefreshController
      ..myFav2BuyrefreshController = myFav2BuyrefreshController
      ..myReleaseList = myReleaseList
      ..buyOrCollectList = buyOrCollectList
      ..commentList = commentList;
    // ..buyController = buyController
    // ..myReleaseController = myReleaseController;
  }
}

MainPaoMineState initState(Map<String, dynamic> args) {
  return MainPaoMineState();
}

/// 我的帖子数据转换
class PaoMinePostListConnector
    extends ConnOp<MainPaoMineState, MainPaoListState>
    with ReselectMixin<MainPaoMineState, MainPaoListState> {
  @override
  MainPaoListState computed(MainPaoMineState state) {
    return MainPaoListState()
      ..dataList = state.myReleaseList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoMineState state) {
    return <dynamic>[...state.myReleaseList];
  }

  @override
  void set(MainPaoMineState state, MainPaoListState subState) {
    state.myReleaseList = subState.dataList;
  }
}

/// 我的收藏购买 数据转换
class PaoMineBuyListConnector extends ConnOp<MainPaoMineState, MainPaoListState>
    with ReselectMixin<MainPaoMineState, MainPaoListState> {
  @override
  MainPaoListState computed(MainPaoMineState state) {
    return MainPaoListState()
      ..dataList = state.buyOrCollectList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoMineState state) {
    return <dynamic>[...state.buyOrCollectList];
  }

  @override
  void set(MainPaoMineState state, MainPaoListState subState) {
    state.buyOrCollectList = subState.dataList;
  }
}

/// 我的评论 数据转换
class PaoMineCommentConnector
    extends ConnOp<MainPaoMineState, MainPaoCommentListState>
    with ReselectMixin<MainPaoMineState, MainPaoCommentListState> {
  @override
  MainPaoCommentListState computed(MainPaoMineState state) {
    return MainPaoCommentListState()
      ..dataList = state.commentList
      ..inited = false;
  }

  @override
  List<dynamic> factors(MainPaoMineState state) {
    return <dynamic>[...state.commentList];
  }

  @override
  void set(MainPaoMineState state, MainPaoCommentListState subState) {
    state.commentList = subState.dataList;
  }
}
