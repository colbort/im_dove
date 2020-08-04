import 'package:app/page/upload_vedio_page/action.dart';
import 'package:app/page/upload_vedio_page/state.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Widget imageUploadView(
    UploadVedioState state, Dispatch dispatch, Function selectImage) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: Wrap(
      spacing: s.realW(11),
      runSpacing: s.realW(11),
      children: <Widget>[
        ...List.generate(
          state.selectedImages.length,
          (int i) => Stack(
            children: [
              AssetThumb(
                asset: state.selectedImages[i],
                width: s.realW(102).toInt(),
                height: s.realH(102).toInt(),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    List newImageList = state.selectedImages;
                    newImageList.removeAt(i);
                    dispatch(
                        UploadVedioActionCreator.updateImageList(newImageList));
                  },
                  child: Container(
                    color: Colors.black54,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        state.selectedImages.length < 9
            ? GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: _uploadImgBtn())
            : Container()
      ],
    ),
  );
}

Widget _uploadImgBtn() {
  return Container(
    color: Color(0xfff3f3f3),
    width: s.realW(102),
    height: s.realH(102),
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffbfbfbf),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: s.realH(40),
              height: s.realW(5),
            ),
          ),
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffbfbfbf),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: s.realH(5),
              height: s.realW(40),
            ),
          )
        ],
      ),
    ),
  );
}
