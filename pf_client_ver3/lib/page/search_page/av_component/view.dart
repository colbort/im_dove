import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(AvState state, Dispatch dispatch, ViewService viewService) {
  return state.searchResp.length == 0
      ? SliverToBoxAdapter(
          child: SizedBox(
            height: s.realH(500),
            child: Center(
              child: Text('无相关数据'),
            ),
          ),
        )
      : SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
          var res = state.searchResp[index];
          var title = res.video.title;
          var tags = res.tags;
          var img = res.video.coverImg[0];
          var playTime = secFmt(state.searchResp[index].video.playTime);
          var watchTime =
              res.totalWatchTimes > 0 ? '${res.totalWatchTimes}次观看' : '';
          var actorName = res.actors.isNotEmpty ? res.actors[0]['name'] : '';

          var id = res.video.id;
          return GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, 'videoPage',
                  arguments: {'videoId': id});
            },
            child: Container(
              width: s.sreenDefaultW,
              height: 100,
              //  color: Colors.black,
              margin: EdgeInsetsDirectional.only(bottom: s.realH(8)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                              child: Container(
                            height: 118,
                            child: CachedNetworkImage(
                              imageUrl: getImgDomain() + img,
                              cacheManager: ImgCacheMgr(),

                              // default_man
                              fit: BoxFit.cover,
                            ),
                          )),
                          Positioned(
                            child: Container(
                              color: Color(0x77000000),
                            ),
                            height: s.realH(25),
                            width: s.sreenDefaultW,
                            bottom: 0,
                          ),
                          Positioned(
                            left: s.realW(5),
                            bottom: s.realH(5),
                            child: Text(
                              playTime,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          Positioned(
                            right: s.realW(5),
                            bottom: s.realH(5),
                            child: SizedBox(
                              width: s.realW(100),
                              child: Text(
                                actorName,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                              child: Container(
                            color: Colors.white,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 3, right: 3),
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              tags.length > 0
                                  ? Container(
                                      margin: EdgeInsetsDirectional.only(
                                          top: s.realH(5)),
                                      height: s.realH(18),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tags.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      start: s.realW(5)),
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      s.realW(8),
                                                      s.realH(1),
                                                      s.realW(8),
                                                      s.realH(3)),
                                              child: Center(
                                                child: Text(
                                                  tags[i],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffF7D35B),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                            );
                                          }),
                                    )
                                  : Container()
                            ],
                          ),
                          Positioned(
                              left: s.realW(3),
                              bottom: s.realH(5),
                              child: Text(
                                watchTime,
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ))
                ],
              ),
            ),
          );
        }, childCount: state.searchResp.length));
}
