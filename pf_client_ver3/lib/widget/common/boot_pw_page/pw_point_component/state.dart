import 'package:fish_redux/fish_redux.dart';

class PwPointState implements Cloneable<PwPointState> {
  /// 已经输入了多少位密码
  int typedPwLen = 0;
  bool isShowAnimate = false;

  @override
  PwPointState clone() {
    return PwPointState()
      ..typedPwLen = typedPwLen
      ..isShowAnimate = isShowAnimate;
  }
}

PwPointState initState(Map<String, dynamic> args) {
  return PwPointState()
    ..typedPwLen = 0
    ..isShowAnimate = false;
}
