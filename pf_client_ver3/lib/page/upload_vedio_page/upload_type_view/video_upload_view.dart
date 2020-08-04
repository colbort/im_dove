import 'dart:io';

import 'package:app/page/upload_vedio_page/state.dart';
import 'package:app/page/upload_vedio_page/upload_type_view/defaultView.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

Widget videoUploadView(UploadVedioState state, Dispatch dispatch,
    Function selectVideoCover, Function selectPreviewVd) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Container(
          width: s.realW(333),
          height: s.realH(174),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
                image: state.updateVdImage != null
                    ? FileImage(File(state.updateVdImage))
                    : AssetImage(""),
                fit: BoxFit.cover,
                alignment: Alignment.center),
          ),
        ),
        Container(
          width: s.realW(333),
          height: s.realH(130),
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              state.updateLocalImage != null
                  ? Container(
                      width: s.realW(165),
                      height: s.realH(130),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(
                            image: FileImage(File(state.updateLocalImage)),
                            fit: BoxFit.cover,
                            alignment: Alignment.center),
                      ),
                    )
                  : uploadTypeItem(state,
                      iconSvgString: 'assets/common/upcover.svg',
                      label: '上传封面', tabHandle: () {
                      selectVideoCover();
                    }),
              state.previewVideoImage != null
                  ? Container(
                      width: s.realW(165),
                      height: s.realH(130),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(
                            image: FileImage(File(state.previewVideoImage)),
                            fit: BoxFit.cover,
                            alignment: Alignment.center),
                      ),
                    )
                  : uploadTypeItem(state,
                      iconSvgString: 'assets/common/videoClick.svg',
                      label: '预览影片', tabHandle: () {
                      selectPreviewVd();
                    }),
            ],
          ),
        )
      ],
    ),
  );
}
