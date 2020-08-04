import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/search_page/action.dart';
import 'package:app/utils/comm.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

//炮友组件
Widget paoFriendList(PaoBaState state, Dispatch dispatch) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(
            left: s.realW(16), top: s.realH(10), bottom: s.realH(10)),
        width: 50,
        child: Stack(
          children: <Widget>[
            Positioned(
                bottom: 0,
                child: Container(
                  height: s.realH(10),
                  width: s.realW(44),
                  decoration: BoxDecoration(
                      color: Color(0xffFFE300),
                      borderRadius: BorderRadius.circular(25.0)),
                )),
            Center(
              child: Text(
                Lang.PAOYOU,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: s.realH(10)),
        height: s.realH(120),
        child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            controller: state.refreshUserController,
            footer: ClassicFooter(
                loadingText: Lang.JIAZAIZHONG,
                canLoadingText: Lang.SONGKAIJIAZAIGENGDUO,
                noDataText: Lang.MEIYOUGENGDUOSHUJU,
                idleText: Lang.ZUOLAJIAZAIGENGDUO,
                loadingIcon: Container(
                    margin: EdgeInsetsDirectional.only(start: s.realW(15)),
                    child: Icon(Icons.autorenew, color: Colors.grey)),
                idleIcon: Container(
                    margin: EdgeInsetsDirectional.only(start: s.realW(15)),
                    child: Icon(Icons.arrow_back, color: Colors.grey)),
                textStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal)),
            onLoading: () {
              dispatch(MainSearchActionCreator.onSearchNextUserData());
            },
            onRefresh: () {},
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.userList.length,
                itemBuilder: (context, index) {
                  var name = state.userList[index]['nickName'];

                  var id = state.userList[index]['id'];
                  var attention = state.userList[index]['attention'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        page_main_pao_other,
                        arguments: {"userId": id, "name": name},
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: index == 0 ? s.realW(16) : s.realW(10)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.3, color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: s.realH(11))),

                          SizedBox(
                            height: s.realW(42),
                            width: s.realW(42),
                            child: CachedNetworkImage(
                              cacheManager: ImgCacheMgr(),
                              imageUrl: state.userList[index]['logo'] == null ||
                                      state.userList[index]['logo'] == ''
                                  ? ''
                                  : getImgDomain() +
                                      state.userList[index]['logo'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: s.realW(42),
                                width: s.realW(42),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(21)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              //placeholder: (context, url) => placeholder,
                              errorWidget: (context, url, error) => SizedBox(
                                  height: s.realW(42),
                                  width: s.realW(42),
                                  child: Center(child: Icon(Icons.error))),
                            ),
                          ),

                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(s.realW(65)),
                          //   child: CachedNetworkImage(
                          //     imageUrl: getImgDomain() +
                          //         state.userList[index]['logo'],
                          //     cacheManager: ImgCacheMgr(),
                          //     // placeholder: (context, url) =>
                          //     //     CircularProgressIndicator(),
                          //     errorWidget: (context, url, error) {
                          //       print('errorWidget');
                          //       return Container(
                          //         color: Colors.red,
                          //         width: 100,
                          //         height: 100,
                          //       );
                          //     },
                          //     width: s.realW(42),
                          //     height: s.realW(42),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(
                                left: s.realW(8),
                                right: s.realW(8),
                                top: s.realH(3)),
                            child: Text(
                              state.userList[index]['nickName'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //关注或取消关注
                              if (attention)
                                dispatch(
                                    PaoBaActionCreator.onCancelAttentionUser(
                                        id));
                              else
                                dispatch(
                                    PaoBaActionCreator.onAttentionUser(id));
                            },
                            child: Container(
                              width: s.realW(72),
                              height: s.realH(26),
                              margin: EdgeInsets.only(top: s.realH(4)),
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child: SvgPicture.asset(
                                          'assets/common/tag.svg')),
                                  Center(
                                    child: Text(
                                      state.userList[index]['attention']
                                          ? Lang.QUXIAOGUANZHUI
                                          : Lang.GUANZHU,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: s.realW(88),
                      height: s.realH(114),
                    ),
                  );
                })),
      )
    ],
  );
}
