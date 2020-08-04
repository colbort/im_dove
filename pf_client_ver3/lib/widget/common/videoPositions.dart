import 'package:app/config/colors.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/image_cache/image_loader.dart';
import 'package:app/lang/lang.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/material.dart';

// 付费影片
Widget isPayPosition({String price}) =>
    Stack(alignment: Alignment.center, children: [
      Positioned(
        left: 0,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
          child: ImageLoader.withP(
            ImageType.IMAGE_SVG,
            ImgCfg.COMMON_AV_GREEN,
            width: Dimens.pt50,
            height: Dimens.pt19,
          ).load(),
        ),
      ),
      price != null
          ? Positioned(
              left: price.length > 3 ? 5 : 10,
              top: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ImageLoader.withP(ImageType.IMAGE_SVG, ImgCfg.MAIN_ICON_COIN,
                          width: Dimens.pt8, height: Dimens.pt12)
                      .load(),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.white,
                    ),
                  )
                ],
              ),
            )
          : Positioned(
              left: 5,
              top: 2,
              child: Text(
                Lang.AV_ALREADY_PURCHASE,
                style: TextStyle(
                  fontSize: 12,
                  color: c.white,
                ),
              ),
            ),
    ]);

// vip影片
Widget isVipPosition = Stack(children: [
  Positioned(
    left: 0,
    top: 0,
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
      ),
      child: ImageLoader.withP(
        ImageType.IMAGE_SVG,
        ImgCfg.COMMON_AV_RED,
        width: Dimens.pt60,
        height: Dimens.pt19,
      ).load(),
    ),
  ),
  Positioned(
    left: 5,
    top: 2,
    child: Text(
      Lang.AV_VIP_FREE,
      style: TextStyle(
        fontSize: 12,
        color: c.white,
      ),
    ),
  ),
]);

//  Positioned(
//           top: 0,
//           right: 0,
//           child: Stack(
//             alignment: Alignment.center,
//             children: <Widget>[
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10),
//                 ),
//                 child: ImageLoader.withP(
//                   ImageType.IMAGE_SVG,
//                   ImgCfg.MAIN_BG_VIDEO_BUY,
//                   width: 85,
//                   height: 26,
//                 ).load(),
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     ImageLoader.withP(
//                             ImageType.IMAGE_SVG, ImgCfg.MAIN_ICON_COIN)
//                         .load(),
//                     Container(
//                       margin: EdgeInsets.only(left: 2),
//                       child: Text(
//                         price,
//                         style: TextStyle(
//                           fontSize: t.fontSize16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
