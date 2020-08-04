import 'package:fish_redux/fish_redux.dart';

class EditPersonState implements Cloneable<EditPersonState> {
  int gender;
  String nickName;
  String logo;

  @override
  EditPersonState clone() {
    return EditPersonState()
      ..gender = gender
      ..nickName = nickName
      ..logo = logo;
  }
}

EditPersonState initState(Map<String, dynamic> args) {
  return EditPersonState()
    ..gender = args['gender']
    ..nickName = args['nickName']
    ..logo = args['logo'];
}
