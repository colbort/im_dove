import 'package:app/page/upload_vedio_page/state.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget defaultUploadView(UploadVedioState state,
    {Function selectVd, Function selectImage}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        uploadTypeItem(state,
            iconSvgString: 'assets/common/videoClick.svg',
            label: '上传视频', tabHandle: () {
          selectVd();
        }),
        uploadTypeItem(state,
            iconSvgString: 'assets/common/upcover.svg',
            label: '上传图片', tabHandle: () {
          selectImage();
        }),
      ],
    ),
  );
}

Widget uploadTypeItem(UploadVedioState state,
    {Function tabHandle, String iconSvgString, String label}) {
  return GestureDetector(
    child: Container(
      width: s.realW(165),
      height: s.realH(130),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffd0d0d0), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        margin: const EdgeInsets.all(3),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SvgPicture.asset(
                iconSvgString,
                width: s.realW(28),
                height: s.realH(28),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12),
              ),
            ])),
      ),
    ),
    onTap: tabHandle,
  );
}
