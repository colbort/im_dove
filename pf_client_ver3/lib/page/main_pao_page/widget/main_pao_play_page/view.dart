import 'package:app/loc_server/vedio_data.dart';
import 'package:app/page/main_pao_page/widget/main_pao_play_page/pao_video_element.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'state.dart';

/// 帖子视频播放
Widget buildView(
    MainPaoPlayState state, Dispatch dispatch, ViewService viewService) {
  var url1 = getRealShortVideoUrl(getTokenFromMem(), state.data.videoURL);

  return SafeArea(
    child: Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          // PaoVideoElement(preInitVideoPlay(getRealVideoUrl(
          //     getTokenFromMem(), state.data.videoId, state.data.videoURL))),
          PaoVideoElement(preInitVideoPlay(url1)),
          Positioned(
            left: 8.0,
            top: 8.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(viewService.context);
              },
              child: Container(
                width: 35,
                height: 35,
                color: Color(0x11010001),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
