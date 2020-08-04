import 'package:fish_redux/fish_redux.dart';
import 'pw_point_component/state.dart';
import 'pw_key_board_component/state.dart';
import 'package:app/config/defs.dart';

class BootPwState implements Cloneable<BootPwState> {
  String typedPw;
  String inputTitle;
  bool isShowAppBar;
  String appBarTitle;
  List<String> sNumList;
  List<String> sCharList;
  String cachePw;
  bool isShow;
  PwPageType type;
  bool isShowAnimate;

  @override
  BootPwState clone() {
    return BootPwState()
      ..typedPw = typedPw
      ..sNumList = sNumList
      ..sCharList = sCharList
      ..inputTitle = inputTitle
      ..appBarTitle = appBarTitle
      ..isShowAppBar = isShowAppBar
      ..isShowAnimate = isShowAnimate
      ..type = type
      ..cachePw = cachePw
      ..isShow = isShow;
  }
}

BootPwState initState(Map<String, dynamic> args) {
  var state = BootPwState()
    ..typedPw = ""
    ..isShowAnimate = false
    ..cachePw = args['cachePw']
    ..type = args['pwType']
    ..inputTitle = args['inputTitle'] != null ? args['inputTitle'] : ''
    ..isShowAppBar = args['isShowAppBar'] != null ? args['isShowAppBar'] : false
    ..appBarTitle = args['appBarTitle'] != null ? args['appBarTitle'] : ''
    ..isShow = args['isShow'] != null ? args['isShow'] : true
    ..sNumList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
    ..sCharList = [
      '',
      'ABC',
      'DEF',
      'GHI',
      'JKL',
      'MNO',
      'PORS',
      'TUV',
      'WXYZ',
      ''
    ];

  return state;
}

class RwPointConnector extends Reselect2<BootPwState, PwPointState, int, bool> {
  @override
  PwPointState computed(int sub0, bool sub1) {
    return PwPointState()
      ..typedPwLen = sub0
      ..isShowAnimate = sub1;
  }

  @override
  int getSub0(BootPwState state) {
    return state.typedPw.length;
  }

  @override
  bool getSub1(BootPwState state) {
    return state.isShowAnimate;
  }

  @override
  void set(BootPwState state, PwPointState subState) {
    throw Exception('Unexcepted to set ToDoListState from ReportState');
  }
}

class PwKeyBoardConnector extends Reselect2<BootPwState, PwKeyBoardState,
    List<String>, List<String>> {
  @override
  PwKeyBoardState computed(List<String> sub0, List<String> sub1) {
    return PwKeyBoardState()
      ..sNumList = sub0
      ..sCharList = sub1;
  }

  @override
  List<String> getSub0(BootPwState state) {
    return state.sNumList;
  }

  @override
  List<String> getSub1(BootPwState state) {
    return state.sCharList;
  }

  @override
  void set(BootPwState state, PwKeyBoardState subState) {
    throw Exception('Unexcepted to set ToDoListState from ReportState');
  }
}
