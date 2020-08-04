import 'package:app/page/comment_page/model/comment_model.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:fish_redux/fish_redux.dart';

enum MainPaoDetailAction {
  action,

  /// 刷新
  onRefresh,

  /// 帖子刷新
  postRefresh,

  /// 评论刷新
  commoentRefresh,
}

class MainPaoDetailActionCreator {
  static Action onAction() {
    return const Action(MainPaoDetailAction.action);
  }

  /// 刷新
  static Action onRefresh() {
    return const Action(MainPaoDetailAction.onRefresh);
  }

  /// 帖子刷新
  static Action postRefresh(PaoDataModel data) {
    return Action(MainPaoDetailAction.postRefresh, payload: data);
  }

  /// 评论刷新
  static Action commoentRefresh(List<CommentModel> list) {
    return Action(MainPaoDetailAction.commoentRefresh, payload: list);
  }
}
