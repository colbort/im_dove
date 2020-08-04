import 'package:app/config/colors.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'state.dart';

/// 我的评论
Widget buildView(
    MainPaoCommentListState state, Dispatch dispatch, ViewService viewService) {
  // var adapte = viewService.buildAdapter();
  return state.dataList.length == 0
      ? Container(
          child: showLoadingWidget(state.inited),
        )
      : MainPaoCommentListWidget(
          commentList: state.dataList,
          dispatch: dispatch,
          viewService: viewService,
        );
}

/// 泡吧page
class MainPaoCommentListWidget extends StatefulWidget {
  final List<PaoCommentModel> commentList;
  final Dispatch dispatch;
  final ViewService viewService;
  const MainPaoCommentListWidget({
    this.commentList,
    this.dispatch,
    this.viewService,
  });

  @override
  MainPaoCommentListWidgetState createState() =>
      MainPaoCommentListWidgetState();
}

class MainPaoCommentListWidgetState extends State<MainPaoCommentListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ComentItemWidget(
          data: widget.commentList[index],
          dispatch: widget.dispatch,
          viewService: widget.viewService,
        );
      },
      itemCount: widget.commentList.length,
    );
  }
}

/// 评论item
class ComentItemWidget extends StatefulWidget {
  final PaoCommentModel data;
  final Dispatch dispatch;
  final ViewService viewService;

  const ComentItemWidget({this.data, this.dispatch, this.viewService});

  @override
  ComentItemWidgetState createState() => ComentItemWidgetState();
}

class ComentItemWidgetState extends State<ComentItemWidget> {
  @override
  Widget build(BuildContext context) {
    return getUserDataWidget();
  }

  /// 获取用户数据widget
  Widget getUserDataWidget() {
    if (widget.data == null) return Container();
    return Container(
      alignment: Alignment.center,
      width: Dimens.pt328,
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.pt16, vertical: Dimens.pt10),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              var mineData = getMineModel();
              if (mineData == null) return;
              if (widget.data.userId == mineData.userId) return;
              Navigator.of(widget.viewService.context).pushNamed(
                page_main_pao_other,
                arguments: {
                  "userId": widget.data.userId,
                  "name": widget.data.name
                },
              );
            },
            child: Container(
              width: Dimens.pt328,
              alignment: Alignment.center,
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
                    width: Dimens.pt328 - Dimens.pt40 - Dimens.pt6,
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /// 名称
                            Text(
                              widget.data.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16, height: 22 / 16),
                            ),

                            // getVipLvWidget(w: Dimens.pt50, lv: widget.data.lv),
                            /// 时间
                            Container(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                showDateDesc(second2DateTime(widget.data.date)),
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(fontSize: 12, color: c.c9E9E9E),
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   // padding: EdgeInsets.symmetric(vertical: 2),
                        //   child: Row(
                        //     children: <Widget>[
                        //       /// 地址icon
                        //       Container(
                        //         padding: EdgeInsets.only(left: 2),
                        //         child: SvgPicture.asset(ImgCfg.MAIN_PAO_ADDR),
                        //       ),

                        //       /// 地址
                        //       Container(
                        //         padding: EdgeInsets.only(left: 2),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           "测试地址",
                        //
                        //           //widget.data.addr ,
                        //           style:
                        //               TextStyle(fontSize: 12, color: c.c9E9E9E),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        /// 类型
                        widget.data.stype == 1
                            ? Container(
                                child: Text(
                                Lang.COMMENT_TIP1,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  height: 17 / 12,
                                ),
                              ))
                            : Container(
                                child: Text(
                                  Lang.COMMENT_TIP2,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    height: 17 / 12,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(widget.viewService.context)
                  .pushNamed(page_main_pao_detail, arguments: {
                "postId": widget.data.postId,
                "replyId": widget.data.id,
                "topId": widget.data.topId
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: Dimens.pt47, left: Dimens.pt46),
              width: Dimens.pt264,
              child: Text(
                widget.data.content,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
