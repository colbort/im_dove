import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/page/comment_page/component/comment_like_widget.dart';
import 'package:app/page/comment_page/model/comment_list_res.dart';
import 'package:app/page/comment_page/model/comment_model.dart';
import 'package:app/page/comment_page/model/reply_list_res.dart';
import 'package:app/page/comment_page/model/reply_model.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/common/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomCommentWidget extends StatefulWidget {
  final int commentTotalCount;

  ///评论对象ID
  final int objectId;

  ///发布人的ID
  final int userId;

  final VoidCallback callback;

  CustomCommentWidget(
      {Key key,
      this.commentTotalCount,
      this.objectId,
      this.userId,
      this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomCommentWidgetState();
  }
}

class CustomCommentWidgetState extends State<CustomCommentWidget> {
  int commentTotalCount = 0;

  int commentPageSize = 10;

  int commentPageIndex = 0;

  ///是否是第一次加载数据
  bool firstLoadingData = true;

  bool isEmpty = false;

  VoidCallback publisherCallback;

  ///评论列表
  List<CommentModel> commentList = [];

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  String textInputTip;

  ///输入控制
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentTotalCount = widget.commentTotalCount;
    _getCommentList();
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///加载中
    if (firstLoadingData) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

    ///数据为空
    if (isEmpty) {
      return _empty();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _header(),
        Expanded(
          flex: 1,
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
                height: Dimens.pt30,
                loadingText: Lang.JIAZAIZHONG,
                canLoadingText: Lang.SONGKAIJIAZAIGENGDUO,
                noDataText: Lang.MEIYOUGENGDUOSHUJU,
                idleText: Lang.SHANGLAJIAZAIGENGDUO,
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 228, 228, 228),
                  fontSize: Dimens.pt12,
                )),
            onLoading: () {
              ///判断是否有更多数据
              if (commentList.length >= commentTotalCount) {
                refreshController.loadNoData();
                return;
              }
              _getCommentList();
              //dispatch(CommentActionCreator.getCommentList());
            },
            controller: refreshController,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _getCommentItem(index);
              },
              itemCount: commentList.length,
            ),
          ),
        ),
        _footerComment(),
      ],
    );
  }

  ///头部
  Widget _header() {
    return Padding(
        padding: EdgeInsets.only(top: Dimens.pt10, bottom: Dimens.pt10),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: Dimens.pt5,
                width: Dimens.pt100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt5)),
                  color: Color.fromARGB(255, 228, 228, 228),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt5),
              ),
              Text(
                '${widget.commentTotalCount}条评论',
                style: TextStyle(
                  color: Color(0xff1e1e1e),
                  fontWeight: FontWeight.w700,
                  fontSize: Dimens.pt14,
                ),
              ),
            ],
          ),
        ));
  }

  ///底部评论提示框
  Widget _footerComment() {
    return GestureDetector(
      onTap: () {
        _showInput();
      },
      child: Container(
        height: Dimens.pt50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Divider(
              height: Dimens.pt5,
              indent: 0,
              color: Colors.grey,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: Dimens.pt10),
                      child: Text(
                        Lang.COMMENT_INPUT_TIP,
                        style: TextStyle(
                            color: Colors.grey, fontSize: Dimens.pt14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Dimens.pt10),
                    child: SvgPicture.asset(
                      ImgCfg.COMMENT_SEND,
                      width: Dimens.pt21,
                      height: Dimens.pt21,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///空数据
  Widget _empty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _header(),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt20),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  Lang.COMMENT_NO_DATA,
                  style: TextStyle(color: Colors.grey, fontSize: Dimens.pt16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt5),
              ),
              Text(
                Lang.COMMENT_NO_DATA,
                style: TextStyle(color: Colors.black, fontSize: Dimens.pt16),
              ),
            ],
          ),
        ),
        _footerComment(),
      ],
    );
  }

  Widget _getCommentItem(int parentIndex) {
    CommentModel commentModel = commentList[parentIndex];
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimens.pt10, Dimens.pt5, Dimens.pt10, Dimens.pt5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ///跳转用户中心界面 todo
                  },
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: commentModel.userInfo == null
                          ? ""
                          : commentModel.userInfo.portrait ?? '',
                      cacheManager: ImgCacheMgr(),
                      placeholder: (BuildContext context, String url) {
                        return SvgPicture.asset(
                          ImgCfg.MINE_DEFAULT_MAN,
                          width: Dimens.pt30,
                          height: Dimens.pt30,
                        );
                      },
                      width: Dimens.pt30,
                      height: Dimens.pt30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.pt5),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "${commentModel.userInfo.userName}",
                            style: TextStyle(
                                color: Color.fromARGB(255, 168, 168, 168),
                                fontSize: Dimens.pt14,
                                fontWeight: FontWeight.w300),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.pt5),
                          ),
                          Offstage(
                            offstage:
                                widget.userId != commentModel.userInfo.userId,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(Dimens.pt2),
                                child: Text(
                                  Lang.AUTHOR,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt8),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.pt5),
                          ),

                          ///todo 性别需要进行判断
                          SvgPicture.asset(
                            commentModel.userInfo.sex == 1
                                ? ImgCfg.MINE_MAN
                                : ImgCfg.MINE_FEMALE,
                            width: Dimens.pt12,
                            height: Dimens.pt12,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.pt5),
                          ),
                        ],
                      ),
                      Text(
                        commentModel.text,
                        style: TextStyle(
                          color: Color(0xff1e1e1e),
                          fontSize: Dimens.pt13,
                        ),
                        maxLines: 3,
                      ),
                      Text(
                        "成都",

                        /// todo地址需要获取
                        style: TextStyle(
                          color: Color.fromARGB(255, 228, 228, 228),
                          fontSize: Dimens.pt10,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                LikeWidget(
                  isLike: commentModel.isLike,
                  likeCount: commentModel.likeCount,
                  callback: (isLike) {
                    if (isLike) {
                      _sendLike(
                        parentIndex,
                      );
                    } else {
                      _cancelLike(
                        parentIndex,
                      );
                    }
                  },
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: Dimens.pt25, top: Dimens.pt5),
              child: ListView.builder(
                  itemCount: commentModel.replyList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _getReplyItem(parentIndex, index);
                  }),
            ),
            GestureDetector(
              onTap: () {
                ///获取更多回复
                _getReplyList(parentIndex);
              },
              child: Offstage(
                offstage: !(commentModel.replyHasNext == null
                    ? true
                    : commentModel.replyHasNext),
                child: Container(
                  padding: EdgeInsets.only(
                      left: Dimens.pt45,
                      bottom: Dimens.pt2,
                      top: Dimens.pt3,
                      right: Dimens.pt10),
                  child: Text(
                    "-----${Lang.COMMENT_SHOW_MORE_REPLY}",
                    style: TextStyle(color: Colors.grey, fontSize: Dimens.pt10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _showInput(parentIndex: parentIndex);
      },
    );
  }

  /// 二级回复 item
  Widget _getReplyItem(int parentIndex, int childIndex) {
    ReplyModel replyModel = commentList[parentIndex].replyList[childIndex];
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimens.pt10, Dimens.pt2, Dimens.pt0, Dimens.pt2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ///跳转用户中心界面 todo
                  },
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: replyModel.userInfo == null
                          ? ""
                          : replyModel.userInfo.portrait ?? "",
                      cacheManager: ImgCacheMgr(),
                      placeholder: (BuildContext context, String url) {
                        return SvgPicture.asset(
                          ImgCfg.MINE_DEFAULT_MAN,
                          width: Dimens.pt30,
                          height: Dimens.pt30,
                        );
                      },
                      width: Dimens.pt30,
                      height: Dimens.pt30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.pt5),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        replyModel.parentId != 0 &&
                                replyModel.parentId != replyModel.replyId
                            ? "${replyModel.userInfo.userName} 回复：${replyModel.replyUserInfo.userName}"
                            : replyModel.userInfo.userName,
                        style: TextStyle(
                          color: Color.fromARGB(255, 168, 168, 168),
                          fontSize: Dimens.pt14,
                          fontWeight: FontWeight.w300,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                      Text(
                        replyModel.replyUserInfo != null
                            ? replyModel.text
                            : replyModel.text,
                        style: TextStyle(
                            color: Color(0xff1e1e1e),
                            fontSize: Dimens.pt13,
                            height: 20 / 13),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                LikeWidget(
                  isLike: replyModel.isLike,
                  likeCount: replyModel.likeCount,
                  callback: (isLike) {
                    if (isLike) {
                      _sendLike(parentIndex, childIndex: childIndex);
                    } else {
                      _cancelLike(parentIndex, childIndex: childIndex);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        _showInput(parentIndex: parentIndex, childIndex: childIndex);

        ///点击评论进行回复,弹出评论对话框
      },
    );
  }

  ///获取评论列表
  void _getCommentList() async {
    Map<String, dynamic> param = {};
    param['postId'] = widget.objectId;
    param['skip'] = commentPageIndex * PAGE_SIZE_10;
    param['limit'] = PAGE_SIZE_10;
    var resp = await net.request(Routers.COMMENT_LIST, args: param);
    if (resp.code == Code.SUCCESS) {
      CommentListRes commentListRes = CommentListRes.fromMap(resp.data);
      if (commentListRes?.commentList != null &&
          commentListRes.commentList.isNotEmpty) {
        _handleComment(commentListRes);
        if (commentListRes.commentList.length < PAGE_SIZE_10)
          refreshController.loadNoData();
      } else {
        firstLoadingData = false;
        isEmpty = true;
        if (mounted) setState(() {});
      }
    } else {
      showToast(resp.msg());
    }
  }

  ///处理评论列表数据
  _handleComment(CommentListRes commentListRes) {
    if (firstLoadingData) {
      firstLoadingData = false;
    }
    commentPageIndex += 1;
    isEmpty = false;
    commentTotalCount =
        widget.commentTotalCount; //commentListRes.commentList.length;
    List<CommentModel> cList = [];
    List<ReplyModel> rList = [];
    commentListRes.commentList.forEach((CommentModel commentModel) {
      if (commentModel.parentId == null || commentModel.parentId == 0) {
        cList.add(commentModel);
      } else {
        rList.add(ReplyModel.fromLocalMap(commentModel.toJson()));
      }
    });

    ///数据组装
    for (var commentModel in cList) {
      commentModel.replyList = [];
      for (var replyModel in rList) {
        if (replyModel.parentId == commentModel.commentId) {
          commentModel.replyList.add(replyModel);
          break;
        }
      }
      if (commentModel.replyList.isNotEmpty) {
        commentModel.replyHasNext = true;
      } else {
        commentModel.replyHasNext = false;
      }
      commentList.add(commentModel);
    }
    refreshController.loadComplete();
    setState(() {});
  }

  ///获取回复列表
  _getReplyList(int parentIndex) async {
    // CommentModel commentModel = commentList[parentIndex];
    // ReplyListRes replyListRes = ReplyListRes();

    ///测试数据
    // replyListRes.total = 30;
    // replyListRes.replyList = [];
    // ReplyModel rm;
    // for (int i = 0; i < 10; i++) {
    //   rm = ReplyModel();
    //   rm.commentId = 2234 + i;
    //   rm.parentId = 1234 + i;
    //   rm.likeCount = 1000 + math.Random().nextInt(100);
    //   rm.isLike = i % 2 == 0 ? true : false;
    //   rm.text = "这是我回复的$i条数据这是我回复的$i条数据这是我回复的$i条数据这是我回复的$i条数据这是我回复的$i条数据";
    //   UserInfoModel userInfoModel = UserInfoModel();
    //   userInfoModel.userId = 2111 + i;
    //   userInfoModel.userName = "ppppp$i";
    //   userInfoModel.portrait = "";
    //   rm.userInfo = userInfoModel;
    //   rm.replyUserInfo = userInfoModel;
    //   rm.objectId = 55555;
    //   if (i % 3 == 0) {
    //     replyListRes.replyList.add(rm);
    //   }
    // }
    // commentModel.replyList.addAll(replyListRes.replyList);
    // if (commentModel.replyList.length < replyListRes.total) {
    //   commentModel.replyHasNext = true;
    // } else {
    //   commentModel.replyHasNext = false;
    // }
    // setState(() {});

    Map<String, dynamic> param = {};
    param['postId'] = widget.objectId;
    param['replyId'] = commentList[parentIndex].commentId;
    param['skip'] = commentList[parentIndex].replyList.length;
    param['limit'] = 10;
    var resp = await net.request(Routers.COMMENT_LIST, args: param);
    if (resp.code == Code.SUCCESS) {
      ReplyListRes replyListRes = ReplyListRes.fromMap(resp.data);
      if (replyListRes?.replyList != null &&
          replyListRes.replyList.isNotEmpty) {
        commentList[parentIndex].replyList.addAll(replyListRes.replyList);
        if (replyListRes.total > commentList[parentIndex].replyList.length) {
          commentList[parentIndex].replyHasNext = true;
        } else {
          commentList[parentIndex].replyHasNext = false;
        }
      } else {
        commentList[parentIndex].replyHasNext = false;
      }
      if (mounted) setState(() {});
    } else {
      showToast("${resp.msg()}");
    }
  }

  ///输入框弹出
  _showInput({int parentIndex = -1, int childIndex = -1}) {
    if (parentIndex != -1 && childIndex != -1) {
      textInputTip =
          "回復 ${commentList[parentIndex].replyList[childIndex].userInfo.userName}:";
    } else {
      textInputTip = "";
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Scaffold(
            body: Container(
              height: Dimens.pt80,
              width: double.infinity,
              padding: EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.red,
                      maxLines: 6,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(Dimens.pt10),
                          hintText: Lang.COMMENT_INPUT_TIP,
                          labelText: textInputTip),
                      controller: contentController,
                    ),
                  ),
                  GestureDetector(
                    child: SvgPicture.asset(
                      ImgCfg.COMMENT_SEND,
                      width: Dimens.pt21,
                      height: Dimens.pt21,
                    ),
                    onTap: () {
                      String content = contentController.text;
                      if (content.isEmpty) {
                        showToast("评论内容不可为空");
                        return;
                      }
                      if (content.length > 100) {
                        showToast("评论内容不可大于100字");
                        return;
                      }
                      if (childIndex != -1) {
                        _sendComment(content,
                            parentIndex: parentIndex, childIndex: childIndex);
                      } else {
                        if (parentIndex != -1) {
                          _sendComment(content, parentIndex: parentIndex);
                        } else {
                          _sendComment(content);
                        }
                      }
                      contentController.clear();
                      Navigator.pop(buildContext);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _cancelLike(int parentIndex, {int childIndex = -1}) async {
    var bReplay = childIndex != -1;
    var id = commentList[parentIndex].commentId;
    if (bReplay) {
      id = commentList[parentIndex].replyList[childIndex].commentId;
    }

    var args = {
      "id": id,
    };
    var resp = await net.request(Routers.COMMENT_UNLIKE, args: args);
    if (resp.code != 200) {
      showToast(resp.msg());
      return;
    }
    setState(() {
      if (childIndex == -1) {
        commentList[parentIndex].isLike = false;
        --commentList[parentIndex].likeCount;
        if (commentList[parentIndex].likeCount < 0) {
          commentList[parentIndex].likeCount = 0;
        }
      } else {
        commentList[parentIndex].replyList[childIndex].isLike = false;
        --commentList[parentIndex].replyList[childIndex].likeCount;
        if (commentList[parentIndex].replyList[childIndex].likeCount < 0) {
          commentList[parentIndex].replyList[childIndex].likeCount = 0;
        }
      }
    });
    //cancelLike(param);
  }

  ///点赞
  _sendLike(int parentIndex, {int childIndex = -1}) async {
    var bReplay = childIndex != -1;
    var id = commentList[parentIndex].commentId;
    if (bReplay) {
      id = commentList[parentIndex].replyList[childIndex].commentId;
    }

    var args = {
      "id": id,
    };
    var resp = await net.request(Routers.COMMENT_LIKE, args: args);
    if (resp.code != 200) {
      showToast(resp.msg());
      return;
    }

    setState(() {
      if (childIndex == -1) {
        commentList[parentIndex].isLike = true;
        ++commentList[parentIndex].likeCount;
      } else {
        commentList[parentIndex].replyList[childIndex].isLike = true;
        ++commentList[parentIndex].replyList[childIndex].likeCount;
      }
    });
    //sendLike(param);
  }

  ///发表评论
  _sendComment(String content,
      {int parentIndex = -1, int childIndex = -1}) async {
    var postId = widget.objectId;
    var replyId = 0;
    if (childIndex != -1) {
      replyId = commentList[parentIndex].replyList[childIndex].commentId;
    } else if (parentIndex != -1 && childIndex == -1) {
      replyId = commentList[parentIndex].commentId;
    }
    var text = content;
    var args = {
      "postId": postId,
      "replyId": replyId,
      "text": text,
    };
    print("args:" + args.toString());
    var resp = await net.request(Routers.ADD_COMMENT, args: args);
    if (resp.code != 200) {
      showToast(Lang.COMMENT_FAILD);
      return;
    }
    if (replyId != 0) {
      ReplyModel data = ReplyModel.fromMap(resp.data["reply"]);
      commentList[parentIndex].replyList.add(data);
    } else {
      CommentModel data = CommentModel.fromMap(resp.data["reply"]);
      commentList.insert(0, data);
    }
    isEmpty = false;
    commentTotalCount += 1;
    if (widget.callback != null) widget.callback();
    setState(() {});
  }
}
