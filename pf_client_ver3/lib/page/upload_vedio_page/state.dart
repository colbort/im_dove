import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

enum UploadType { image, video }

class UploadVedioState implements Cloneable<UploadVedioState> {
  var isAgree = false;
  var updateVdImage;
  var updateLocalImage;
  List tags = [];
  List selectedtags = [];
  String videoPath;
  String previewVideoPath;
  String previewVideoImage;
  int moneyLabe = 0;
  UploadType uploadType;
  List<Asset> selectedImages = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  @override
  UploadVedioState clone() {
    return UploadVedioState()
      ..isAgree = isAgree
      ..updateVdImage = updateVdImage
      ..previewVideoImage = previewVideoImage
      ..previewVideoPath = previewVideoPath
      ..updateLocalImage = updateLocalImage
      ..selectedImages = selectedImages
      ..videoPath = videoPath
      ..tags = tags
      ..uploadType = uploadType
      ..selectedtags = selectedtags
      ..titleController = titleController
      ..tagController = tagController
      ..moneyLabe = moneyLabe;
  }
}

UploadVedioState initState(Map<String, dynamic> args) {
  return UploadVedioState()..uploadType = null;
}
