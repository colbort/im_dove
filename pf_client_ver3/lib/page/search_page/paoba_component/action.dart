import 'package:fish_redux/fish_redux.dart';

enum PaoBaAction { onAttentionUser, onCancelAttentionUser }

class PaoBaActionCreator {
  static Action onAttentionUser(int id) {
    return Action(PaoBaAction.onAttentionUser, payload: id);
  }

  static Action onCancelAttentionUser(int id) {
    return Action(PaoBaAction.onCancelAttentionUser, payload: id);
  }
}
