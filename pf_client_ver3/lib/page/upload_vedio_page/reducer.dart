import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UploadVedioState> buildReducer() {
  return asReducer(
    <Object, Reducer<UploadVedioState>>{
      UploadVedioAction.saveTags: _onSaveTags,
      UploadVedioAction.updateAgree: _updateAgree,
      UploadVedioAction.updateVdImage: _updateVdImage,
      UploadVedioAction.updateLocalImage: _updateLocalIamge,
      UploadVedioAction.updateVdFile: _updateVdFile,
      UploadVedioAction.updatePreviewVdImage: _updatePreviewVdImage,
      UploadVedioAction.updatePreviewVdFile: _updatePreviewVdFile,
      UploadVedioAction.moneyLabe: _moneyLabe,
      UploadVedioAction.titlelabel: _titlelabel,
      UploadVedioAction.tagString: _tagString,
      UploadVedioAction.selectedtags: _selectedtags,
      UploadVedioAction.updateImageList: _updateImageList,
    },
  );
}

UploadVedioState _onSaveTags(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.tags = action.payload;
  return newState;
}

UploadVedioState _updateAgree(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.isAgree = action.payload;
  return newState;
}

UploadVedioState _updateVdImage(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.updateVdImage = action.payload;
  newState.uploadType = UploadType.video;
  return newState;
}

UploadVedioState _updateVdFile(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.videoPath = action.payload;
  newState.uploadType = UploadType.video;
  return newState;
}

UploadVedioState _updatePreviewVdFile(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.previewVideoPath = action.payload;
  return newState;
}

UploadVedioState _updatePreviewVdImage(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.previewVideoImage = action.payload;
  return newState;
}

UploadVedioState _updateLocalIamge(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.updateLocalImage = action.payload;
  return newState;
}

UploadVedioState _updateImageList(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.selectedImages = action.payload;
  newState.uploadType = UploadType.image;
  return newState;
}

UploadVedioState _moneyLabe(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.moneyLabe = action.payload;
  return newState;
}

UploadVedioState _titlelabel(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.titleController.text = action.payload;
  return newState;
}

UploadVedioState _tagString(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.tagController.text = action.payload;
  return newState;
}

UploadVedioState _selectedtags(UploadVedioState state, Action action) {
  final UploadVedioState newState = state.clone();
  newState.selectedtags = action.payload;
  return newState;
}
