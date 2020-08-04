import 'package:fish_redux/fish_redux.dart';

class SetPageState implements Cloneable<SetPageState> {
  bool pwChecked;
  String version;
  String phoneNumber;
  double imageCache;
  @override
  SetPageState clone() {
    return SetPageState()
      ..version = version
      ..pwChecked = pwChecked
      ..phoneNumber = phoneNumber
      ..imageCache = imageCache;
  }
}

SetPageState initState(Map<String, dynamic> args) {
  return SetPageState()
    ..pwChecked = false
    ..version = ''
    ..phoneNumber = args['mobile']
    ..imageCache = 0;
}
