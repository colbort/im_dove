import 'package:fish_redux/fish_redux.dart';

class MineChannelState implements Cloneable<MineChannelState> {

  @override
  MineChannelState clone() {
    return MineChannelState();
  }
}

MineChannelState initState(Map<String, dynamic> args) {
  return MineChannelState();
}
