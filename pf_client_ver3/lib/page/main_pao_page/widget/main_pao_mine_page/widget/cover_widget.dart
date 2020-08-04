import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/model/pao_user_data_model.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/commWidget.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../action.dart';

/// 封面
class CoverWidget extends StatefulWidget {
  final PaoUserDataModel userData;
  final Dispatch dispatch;
  final ViewService viewService;
  final bool bSelf;

  const CoverWidget({
    @required this.userData,
    this.dispatch,
    this.viewService,
    this.bSelf = true,
  });

  @override
  KeepAliveState createState() => KeepAliveState();
}

class KeepAliveState extends State<CoverWidget> {
  /// 背景图片
  Widget getBgImgWidget() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: Dimens.pt360,
        height: Dimens.pt190,
        decoration: BoxDecoration(color: Colors.black12),
        child: CachedNetworkImage(
          imageUrl: widget.userData.bgImg,
          cacheManager: ImgCacheMgr(),
          width: Dimens.pt360,
          // height: Dimens.pt190,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// 获取用户数据widget
  /// 头像 名称 地址 关注按钮
  Widget getUserDataWidget() {
    if (widget.userData == null) return Container();
    return Positioned(
      top: Dimens.pt29,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  /// 头像
                  widget.userData.headImg.isEmpty
                      ? SvgPicture.asset(
                          'assets/mine/default_man.svg',
                          width: Dimens.pt40,
                          height: Dimens.pt40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.pt45),
                          child: CachedNetworkImage(
                            imageUrl: getImgDomain() + widget.userData.headImg,
                            cacheManager: ImgCacheMgr(),
                            width: Dimens.pt40,
                            height: Dimens.pt40,
                            fit: BoxFit.cover,
                          ),
                        ),

                  /// 名称 位置
                  Container(
                    margin: EdgeInsets.only(left: Dimens.pt10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            /// 名称
                            Text(
                              widget.userData.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                height: 17 / 14,
                                color: Colors.white,
                              ),
                            ),

                            /// 占位
                            Padding(
                              padding: EdgeInsets.only(left: Dimens.pt10),
                            ),

                            /// 性别
                            getSexWidget(widget.userData.sex),

                            /// vip lv
                            // getVipLvWidget(w: Dimens.pt50, lv: widget.data.lv),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: Dimens.pt4),
                          child: Row(
                            children: <Widget>[
                              /// 地址icon
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                child: SvgPicture.asset(
                                  ImgCfg.MAIN_PAO_ADDR,
                                  color: Colors.white,
                                ),
                              ),

                              /// 地址
                              Container(
                                padding: EdgeInsets.only(left: 2),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.userData.addr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    // color: c.c9E9E9E,
                                    color: Colors.white,
                                  ),
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

            /// 关注
            Offstage(
              offstage: widget.bSelf,
              child: widget.userData.bWatch
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
                        print("关注");
                        // widget.dispatch(
                        //     MainPaoItemActionCreator.onAttention(widget.data.no));
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
            ),
          ],
        ),
      ),
    );
  }

  /// 个人简介
  Widget getIntroWidget() {
    return Positioned(
      top: Dimens.pt88,
      left: 0,
      child: GestureDetector(
        onTap: () {
          if (!widget.bSelf) return;
          var intro = widget.userData.intro;
          showSignDialog(widget.viewService.context, defaultContent: intro,
              callback: (String content) {
            if (content == null || content.isEmpty == true) return;
            if (intro == content) return;
            widget.dispatch(MainPaoMineActionCreator.onUpdateSign(content));
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
          width: Dimens.pt328,
          height: Dimens.pt40,
          child: Text(
            widget.userData.intro,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 3,
          ),
        ),
      ),
    );
  }

  /// 粉丝数量 关注数量
  Widget getFans2WatchWidget() {
    return Positioned(
      left: 0,
      bottom: Dimens.pt35,
      child: Container(
        // width: Dimens.pt150,
        margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: Dimens.pt27),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.userData.fans.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    Lang.FENSI,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    widget.userData.watchs.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    Lang.GUANZHU,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 设置封面
  Widget setFengmianWidget() {
    return Positioned(
      right: 0,
      bottom: Dimens.pt17,
      child: GestureDetector(
        onTap: () {
          getImage();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pt12),
          height: Dimens.pt24,
          width: Dimens.pt88,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.camera_enhance,
                size: 20,
                color: Colors.white,
              ),
              Text(
                Lang.SET_FENGMIAN,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 跳转裁剪换头像
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Navigator.of(widget.viewService.context)
        .pushNamed('mineEditImage', arguments: {
      'image': image,
      'isCover': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.pt360,
      height: Dimens.pt190,
      child: Stack(
        children: <Widget>[
          getBgImgWidget(),
          getUserDataWidget(),
          getFans2WatchWidget(),
          setFengmianWidget(),
          getIntroWidget(),
        ],
      ),
    );
  }
}
