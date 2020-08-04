import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/defaultWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
  VideoRecordState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  return state.records.records.length == 0
      ? showDefaultWidget(DefaultType.noData)
      : ListView(
          padding: EdgeInsets.only(top: 20),
          children: List.generate(state.records?.records?.length ?? 0, (index) {
            var temp = state.records.records[index];
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: state.itemH,
                      width: state.itemW,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ImageLoader.withP(
                          ImageType.IMAGE_NETWORK_HTTP,
                          state.records.records[index].movieCover,
                          height: state.itemH,
                          width: state.itemW,
                        ).load(),
                      ),
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(
                        viewService.context,
                        'videoPage',
                        arguments: {
                          'videoId': int.parse(temp.id),
                          'totalTime': temp.totalTime,
                          'playedTime': temp.playTime,
                        },
                      );
                    },
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    width: state.itemW,
                    height: state.itemH,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(
                            state.records.records[index].movieName,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: c.c333333,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ImageLoader.withP(
                                    ImageType.IMAGE_SVG,
                                    ImgCfg.COMMON_IPAD,
                                    width: Dimens.pt14,
                                    height: Dimens.pt14,
                                  ).load(),
                                  Container(
                                    width: 8,
                                  ),
                                  Text(
                                      '${Lang.AV_WATCH_PERCENT}${temp.percent}%'),
                                ],
                              ),
                              Text(
                                temp.createTime,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: c.cFFA8A8A8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
}
