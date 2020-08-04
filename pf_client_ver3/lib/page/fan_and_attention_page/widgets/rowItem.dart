import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/fan_and_attention_page/state.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget rowItem(
    dynamic item, FanAndAttentionState state, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      if (state.currentId == item['userId']) {
        Navigator.of(viewService.context).pushNamed('portfolioPage');
      } else {
        Navigator.of(viewService.context).pushNamed('otherPortfolioPage',
            arguments: {'uid': item['userId']});
      }
    },
    child: Container(
      padding: EdgeInsets.only(
        left: s.realW(8),
        top: s.realH(5),
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/mine/circle.png'),
                    fit: BoxFit.fill,
                    width: s.realW(39),
                    height: s.realW(39),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: s.realW(34),
                      height: s.realH(34),
                      child: item['vatar'].isNotEmpty
                          ? CircleAvatar(
                              radius: s.realW(30),
                              backgroundColor: Colors.transparent,
                              backgroundImage: CachedNetworkImageProvider(
                                  item['vatar'],
                                  cacheManager: ImgCacheMgr()),
                            )
                          : SvgPicture.asset(
                              ImgCfg.MINE_DEFAULT_MAN,
                              width: s.realW(35),
                              height: s.realW(35),
                            ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: s.realW(8)),
                        child: Text(
                          item['name'],
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: s.realH(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(viewService.context).size.width -
                      s.realW(45),
                  height: 0.5,
                  color: Color(0xff979797),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

//  Widget _renderfansBtn(item){
//     Widget _isFan = Container(
//                 width: 60,
//                 height: 28,
//                 child: FlatButton(
//                   color: const Color(0xfff2351b),
//                   child: Text(
//                     '關注',
//                     maxLines: 1,
//                     style: const TextStyle(
//                         fontSize: 12,
//                         color: const Color(0xffffffff),
//                         fontWeight: FontWeight.normal),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(21.0)),
//                   onPressed: () {},
//                 ),
//               );
//     Widget _cancelFan = Container(
//                 width: 80,
//                 height: 28,
//                 child: FlatButton(
//                   color: Colors.grey,
//                   child: Text(
//                     '取消關注',
//                     maxLines: 1,
//                     style: const TextStyle(
//                         fontSize: 12,
//                         color: const Color(0xffffffff),
//                         fontWeight: FontWeight.normal),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(21.0)),
//                   onPressed: () {},
//                 ),
//               );
//     /// 其他人粉丝
//     if(state.id != null){
//       if(!item['eachOther']){
//         return _isFan;
//       }else{
//         return _cancelFan;
//       }
//     }
//   }
