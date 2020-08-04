import 'package:fish_redux/fish_redux.dart';

enum UploadVedioAction {
  saveTags,
  updateAgree,
  updateVdImage,
  updateLocalImage,
  updateVdFile,
  updatePreviewVdFile,
  updatePreviewVdImage,
  moneyLabe,
  titlelabel,
  tagString,
  updateImageList,
  selectedtags
}

class UploadVedioActionCreator {
  static Action onSaveTags(List list) {
    return Action(UploadVedioAction.saveTags, payload: list);
  }

  static Action updateAgree(bool isAgree) {
    return Action(UploadVedioAction.updateAgree, payload: isAgree);
  }

  static Action updateVdFile(String vdPath) {
    return Action(UploadVedioAction.updateVdFile, payload: vdPath);
  }

  static Action updateVdImage(String imagePath) {
    return Action(UploadVedioAction.updateVdImage, payload: imagePath);
  }

  static Action updatePreviewVdFile(String vdPath) {
    return Action(UploadVedioAction.updatePreviewVdFile, payload: vdPath);
  }

  static Action updatePreviewVdImage(String imagePath) {
    return Action(UploadVedioAction.updatePreviewVdImage, payload: imagePath);
  }

  static Action updateLocalImage(String imagePath) {
    return Action(UploadVedioAction.updateLocalImage, payload: imagePath);
  }

  static Action updateImageList(List list) {
    return Action(UploadVedioAction.updateImageList, payload: list);
  }

  static Action moneyLabe(int money) {
    return Action(UploadVedioAction.moneyLabe, payload: money);
  }

  static Action titlelabel(String title) {
    return Action(UploadVedioAction.titlelabel, payload: title);
  }

  static Action tagString(String tag) {
    return Action(UploadVedioAction.tagString, payload: tag);
  }

  static Action selectedtags(List selectedtags) {
    return Action(UploadVedioAction.selectedtags, payload: selectedtags);
  }
}
