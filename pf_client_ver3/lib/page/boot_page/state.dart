import 'package:fish_redux/fish_redux.dart';

class BootState implements Cloneable<BootState> {
  bool countDown = false;
  int countSeconds = 3;
  bool getAdImg = false;
  String adImgUrl = "";
  String jumpUrl = "";
  bool showingAni = false;

  ///local version
  String version = "";

  @override
  BootState clone() {
    return BootState()
      ..countDown = countDown
      ..getAdImg = getAdImg
      ..adImgUrl = adImgUrl
      ..jumpUrl = jumpUrl
      ..version = version
      ..showingAni = showingAni;
  }
}

BootState initState(Map<String, dynamic> args) {
  return BootState()
    ..countDown = false
    ..getAdImg = false
    ..countSeconds = 3
    ..showingAni = true
    ..adImgUrl = ""
    ..jumpUrl = ""
    ..version = "";
}
