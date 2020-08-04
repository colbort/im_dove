import 'dart:io';

import 'package:app/config/image_cfg.dart';
import 'package:app/event/index.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/lang/lang.dart';
import 'package:app/model/carouse.dart';
import 'package:app/net/net.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/dialogs/assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum SpreadType { modalCenter, flowBottom }
List<Carouse> spreadData;

getSpreadData() async {
  var resData = await net.request(Routers.CAROUSE_LIST_POST, args: {"type": 2});
  if (resData.code == Code.SUCCESS && resData.data != null) {
    spreadData = getCarouseList(resData.data);
  } else {
    spreadData = null;
  }
}

showSpreadPage(BuildContext context) {
  if (spreadData != null) {
    vibrate();
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SpreadPage();
        });
  } else {
    showAssControl(context);
  }
}

/// 小助手弹出提示规则：用户首次进入提示，24小时内紧提示一次，最多提示三次
showAssControl(BuildContext context) async {
  if (!Platform.isIOS) return;
  var _flag = await ls.get(StorageKeys.ASS_FLAG);
  var _num = await ls.get(StorageKeys.ASS_NUM);
  var _comparedTime = 24 * 60 * 60 * 1000;
  if (_flag != 'true' && _num == null && _flag == null) {
    assistantDialog(context);
    return;
  }
  if (_flag != 'true' && int.parse(_num) < 2) {
    var _nowMills = DateTime.now().millisecondsSinceEpoch;
    if (_nowMills - int.parse(_flag) > _comparedTime) {
      assistantDialog(context);
    }
  }
}

class SpreadPage extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Stack(children: <Widget>[
        Center(
          //保证控件居中效果
          child: GestureDetector(
            onTap: () {
              onSpreadBannerClick(context, SpreadType.modalCenter);
            },
            child: CachedNetworkImage(
                imageUrl: spreadData[0].linkImg,
                cacheManager: ImgCacheMgr(),
                width: MediaQuery.of(context).size.width - 100,
                fit: BoxFit.fitWidth),
          ),
        ),
        Positioned(
            right: 50,
            top: MediaQuery.of(context).size.height / 2 - 220,
            child: GestureDetector(
              onTap: () {
                _onSpreadDismiss(context);
                statusBarEvent.fire(null);
              },
              child: SvgPicture.asset(
                ImgCfg.COMMON_SPREAD_CLOSE_ICON,
                width: 40,
                height: 40,
                fit: BoxFit.fill,
              ),
            ))
      ]),
    );
  }
}

onSpreadBannerClick(BuildContext context, SpreadType spreadType) {
  final Carouse data = spreadData[0];
  // data.linkType = 1;
  // data.jumpApp = "203";
  // print("test _onImgClick ${data.linkType}");
  if (spreadType == SpreadType.modalCenter) {
    _onSpreadDismiss(context);
  }
  switch (data.linkType) {
    case 1:
      //跳转专题3.0去掉了
      // SpreadPage.spreadPageDelegate
      //     .broadcast(MainActionCreator.onSwitchToTopicAction(data.jumpApp));
      break;
    case 2:
      Navigator.of(context).pushNamed('WebviewPage',
          arguments: {'url': data.jumpH5 ?? "", 'pageName': Lang.GUANGGAO});
      break;
    case 3:
      Navigator.of(context).pushNamed('WalletPage');
      break;
    case 4:
      Navigator.of(context).pushNamed('Promotionpage');
      break;
    case 5:
      Navigator.of(context)
          .pushNamed('WebviewPage', arguments: {'url': data.jumpH5 ?? ""});
      break;
    case 6:
      Navigator.of(context).pushNamed('vipNewPage');
      break;
    default:
  }
}

_onSpreadDismiss(BuildContext context) {
  Navigator.of(context).pop();
  showAssControl(context);
}
