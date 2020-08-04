import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'main_pao_item_component/action.dart';
import 'main_pao_picture.dart';
import 'main_pao_video.dart';

/// 泡吧item
class MainPaoItemWidget extends StatefulWidget {
  final PaoDataModel data;
  final Dispatch dispatch;
  final ViewService viewService;
  final bool bShowUserData;

  final Function onOptCallbackFn;
  const MainPaoItemWidget({
    this.data,
    this.dispatch,
    this.viewService,
    this.bShowUserData = true,
    this.onOptCallbackFn,
  });

  @override
  MainPaoItemWidgetState createState() => MainPaoItemWidgetState();
}

class MainPaoItemWidgetState extends State<MainPaoItemWidget> {
  /// 获取用户数据widget
  Widget getUserDataWidget() {
    if (widget.data == null) return Container();
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsetsDirectional.only(top: Dimens.pt16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              var mineData = getMineModel();
              if (mineData == null) return;
              if (widget.data == null || widget.data.userId == null) return;
              if (widget.data.userId == mineData.userId) return;
              Navigator.of(widget.viewService.context)
                  .pushNamed(page_main_pao_other, arguments: {
                "userId": widget.data.userId,
                "name": widget.data.name
              });
            },
            child: Container(
              child: Row(
                children: [
                  /// 头像
                  widget.data.headImg.isEmpty
                      ? SvgPicture.asset(
                          'assets/mine/default_man.svg',
                          width: Dimens.pt40,
                          height: Dimens.pt40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.pt45),
                          child: CachedNetworkImage(
                            imageUrl: getImgDomain() + widget.data.headImg,
                            cacheManager: ImgCacheMgr(),
                            width: Dimens.pt40,
                            height: Dimens.pt40,
                            fit: BoxFit.cover,
                          ),
                        ),

                  /// 名称 等级 时间 位置
                  Container(
                    margin: EdgeInsets.only(left: Dimens.pt6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            /// 名称
                            Text(
                              widget.data.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14, height: 17 / 14),
                            ),

                            getVipLvWidget(w: Dimens.pt50, lv: widget.data.lv),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: <Widget>[
                              /// 时间
                              Container(
                                padding: EdgeInsets.only(top: 2),
                                child: Text(
                                  getDateFmt(widget.data.date),
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontSize: 12, color: c.c9E9E9E),
                                ),
                              ),

                              /// 地址icon
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: SvgPicture.asset(ImgCfg.MAIN_PAO_ADDR),
                              ),

                              /// 地址
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                alignment: Alignment.center,
                                width: Dimens.pt100,
                                child: Text(
                                  widget.data.addr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: c.c9E9E9E,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
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
            ),
          ),

          /// 关注
          widget.data.bAttention || checkWatchList(widget.data.userId)
              ? Container(
                  alignment: Alignment.center,
                  width: Dimens.pt78,
                  height: Dimens.pt28,
                  child: Text(
                    Lang.YIGUANZHU,
                    style: TextStyle(fontSize: 14, color: c.cC9C9C9),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    widget.dispatch(
                        MainPaoItemActionCreator.onAttention(widget.data.no));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: Dimens.pt78,
                    height: Dimens.pt28,
                    decoration: BoxDecoration(
                      color: c.cFFE300,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      Lang.GUANZHU,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  /// 获取文本内容
  Widget getContentWidget() {
    if (widget.data?.content?.isEmpty == true)
      return Container(
        margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
      );
    return Container(
      //color: Colors.red,
      width: Dimens.pt328,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// 文本内容
          Flexible(
            child:

                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
                //   child: widget.data.bExpand
                //       ? Text(
                //           widget.data.content,
                //           style: TextStyle(fontSize: 14),
                //           // softWrap: true,
                //         )
                //       : Text(
                //           widget.data.content,
                //           style: TextStyle(
                //             fontSize: 14,
                //           ),
                //           maxLines: 3,
                //           overflow: TextOverflow.ellipsis,
                //           // softWrap: true,
                //         ),
                // ),

                Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: Dimens.pt16),
                  child: widget.data.bExpand
                      ? Text(
                          widget.data.content,
                          style: TextStyle(fontSize: 14),
                          // softWrap: true,
                        )
                      : Text(
                          widget.data.content,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          // softWrap: true,
                        ),
                ),
                // Positioned(
                //   bottom: Dimens.pt16,
                //   right: 2,
                //   child: Offstage(
                //     offstage: widget.data.content.length < 100,
                //     child: Container(
                //       color: Colors.white,
                //       child: Text(
                //         "   展开",
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: c.cFF82C4F9,
                //           // color: Colors.red,
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Offstage(
            offstage: !widget.data.bSelf,
            child: Container(
              height: 40,
              margin: EdgeInsets.only(left: Dimens.pt4, top: Dimens.pt20),
              child: Text(
                "审核中",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ���取标签
  Widget getFlagWidget() {
    if (widget.data?.flagList?.length == 0) return Container();
    List<Widget> list = [];
    var len = widget.data.flagList.length > 4 ? 4 : widget.data.flagList.length;
    for (var i = 0; i < len; i++) {
      var str = widget.data.flagList[i];
      var colorData = getFlagColors(str);
      list.add(Container(
        margin: EdgeInsets.only(right: Dimens.pt6),
        width: Dimens.pt74,
        height: Dimens.pt26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorData["b"],
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          "#" + str,
          style: TextStyle(
            fontSize: 12,
            color: colorData["t"],
          ),
        ),
      ));
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.pt6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: list,
      ),
    );
  }

  Widget getOptWidget() {
    return Container(
      margin: EdgeInsets.only(top: Dimens.pt6),
      width: Dimens.pt328,
      height: Dimens.pt28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// 收藏
          GestureDetector(
            onTap: () {
              widget
                  .dispatch(MainPaoItemActionCreator.onCollect(widget.data.no));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(widget.data.isCollect
                      ? ImgCfg.MAIN_PAO_HEART
                      : ImgCfg.MAIN_PAO_HEART_NORMAL),
                  Container(
                    margin: EdgeInsets.only(left: Dimens.pt2),
                    child: Text(widget.data.totalCollect.toString()),
                  )
                ],
              ),
            ),
          ),

          /// 评论
          GestureDetector(
            onTap: () {
              widget
                  .dispatch(MainPaoItemActionCreator.onComment(widget.data.no));
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(ImgCfg.MAIN_PAO_COMMENT_NORMAL),
                  Container(
                    margin: EdgeInsets.only(left: Dimens.pt2),
                    child: Text(widget.data.totalComment.toString()),
                  )
                ],
              ),
            ),
          ),

          /// 点赞 删除
          Container(
            child: Row(
              children: <Widget>[
                /// 点赞
                GestureDetector(
                  onTap: () {
                    widget.dispatch(
                        MainPaoItemActionCreator.onLike(widget.data.no));
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(widget.data.isLike
                          ? ImgCfg.LIKE_SELECTED
                          : ImgCfg.LIKE_NORMAL),
                      Container(
                        margin: EdgeInsets.only(
                            left: Dimens.pt2, right: Dimens.pt12),
                        child: Text(widget.data.totalLike.toString()),
                      )
                    ],
                  ),
                ),

                Offstage(
                  offstage: !(widget.data.bSelf && widget.data.status == 1),
                  child: Container(
                    height: 30,
                    // width: 30,
                    alignment: Alignment.center,
                    child: PopupMenuButton<String>(
                      color: Colors.white,
                      // padding: EdgeInsets.all(0),
                      offset: Offset(-30, -30),
                      onSelected: (String result) {
                        if (result == "del") {
                          widget.dispatch(MainPaoItemActionCreator.onDelPost(
                              widget.data.no));
                        }
                      },
                      icon: Text(
                        ". . .",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                          value: "del",
                          height: 16,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(Lang.DELETE_POST),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
            child: Column(
              children: <Widget>[
                widget.bShowUserData
                    ? (widget.data.bSelf ? Container() : getUserDataWidget())
                    : Container(),
                getContentWidget(),
                Offstage(
                  offstage: !(widget.data.typ == 1),
                  child: widget.data.picList != null &&
                          widget.data.picList.length >= 0
                      ? MainPaoPicture(
                          picList: widget.data.picList,
                          data: widget.data,
                          onOptCallbackFn: widget.onOptCallbackFn,
                        )
                      : Container(),
                ),
                Offstage(
                  offstage: !(widget.data.typ == 2),
                  child: MainPaoVideo(
                    isPlay: widget.data.bPlaying,
                    paoDataModel: widget.data,
                    onOptCallbackFn: widget.onOptCallbackFn,
                  ),
                ),
                getFlagWidget(),
                getOptWidget(),
              ],
            ),
          ),
          getHengLine(h: 4.0),
        ],
      ),
    );
  }
}
