import 'dart:io';

import 'package:fish_redux/fish_redux.dart';

class EditImgState implements Cloneable<EditImgState> {
  File image;
  bool isCover;
  @override
  EditImgState clone() {
    return EditImgState()..image = image;
  }
}

EditImgState initState(Map<String, dynamic> args) {
  return EditImgState()
    ..image = args['image']
    ..isCover = args['isCover'];
}
