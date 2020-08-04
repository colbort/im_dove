import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/config/colors.dart';
import 'package:app/lang/lang.dart';
import 'package:app/loc_server/vedio_data.dart';
import 'package:app/page/main_mine_page/models/mine_model.dart';
import 'package:app/page/wallet_page/effect.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/logger.dart';
import 'package:app/widget/common/picture_page_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'hosts.dart';
// import 'package:vibrate/vibrate.dart';
// import 'package:path_provider/path_provider.dart';

// ///获取设备id
// Future<String> getDeviceID() async {
//   return n.getUUID();
// }

/// 通过string转换成json对象
/// [return] 空是错误或者格式不对， 非空就是json对象
Map<String, dynamic> jsonFrom(String str) {
  Map<String, dynamic> obj;
  try {
    obj = json.decode(str);
  } on FormatException {
    log.e('[json] 格式不对');
  } on Error catch (e) {
    log.e('[json] ${e.toString()}');
  }
  return obj;
}

/// 全局key 方便保存全局context
GlobalKey<NavigatorState> navigatorKey = GlobalKey();
BuildContext getAppContext() {
  return navigatorKey.currentContext;
}

/// 把json对象转换成string
/// [return] 空是错误或者格式不对， 非空就是json对象
String jsonTo(Map<String, dynamic> obj) {
  String str;
  try {
    str = json.encode(obj);
  } on FormatException {
    log.e('[json] 格式不对');
  } on Error catch (e) {
    log.e('[json] ${e.toString()}');
  }
  return str;
}

var _token = '';
Future<String> getToken() async {
  if (_token != null && _token.isNotEmpty) return _token;
  return _token = await ls.get(StorageKeys.TOKEN);
}

Future<bool> setToken(String token) async {
  _token = token;
  return await ls.save(StorageKeys.TOKEN, token);
}

Future<bool> delToken() async {
  _token = "";
  return await ls.remove(StorageKeys.TOKEN);
}

getTokenFromMem() {
  return _token;
}

///刚刚，多少分钟前，多少小时前，一天前，两天前，三天前
String showDateDesc(DateTime time) {
  if (time == null) return '';
  var csec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var osec = time.millisecondsSinceEpoch ~/ 1000;

  var diff = csec - osec;
  // 一分钟内
  if (diff < 60) return Lang.tJustnow;
  // 一个小时内
  if (diff < (60 * 60)) return Lang.val(Lang.tMin, args: [diff ~/ 60]);
  // 一天内
  if (diff < (60 * 60 * 24)) return Lang.val(Lang.tHour, args: [diff ~/ 3600]);

  return Lang.val(Lang.tDay, args: [min(diff ~/ 86400, 3)]);
}

///剩余时间
int showLestDay(String date) {
  if (date == null) return 0;
  DateTime time = DateTime.parse(date);
  if (time == null) return 0;
  var csec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var osec = time.millisecondsSinceEpoch ~/ 1000;

  var diff = osec - csec;
  var lestDay = diff ~/ (60 * 60 * 24);
  print(
      '${diff ~/ (60 * 60 * 24)}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
  // 一分钟内
  // if (diff < 60) return Lang.tJustnow;
  // // 一个小时内
  // if (diff < (60 * 60)) return Lang.val(Lang.tMin, args: [diff ~/ 60]);
  // // 一天内
  // if (diff < (60 * 60 * 24)) return Lang.val(Lang.tHour, args: [diff ~/ 3600]);

  return lestDay;
}

// ///年-月-日
// String showDateDesc1(String time) {
//   if (time.length <= 0) return "1970-01-01";
//   var date = DateTime.parse(time).toLocal();
//   var y = date.year.toString();
//   var m = date.month.toString().padLeft(2, '0');
//   var day = date.day.toString().padLeft(2, '0');
//   // var h = date.hour.toString().padLeft(2, '0');
//   // var min = date.minute.toString().padLeft(2, '0');
//   // var s = date.second.toString().padLeft(2, '0');
//   var str = y + "-" + m + "-" + day;
//   return str;
// }

/// 根据毫秒计算 年-月-日
/// toData 转换毫秒为日期字符串 yyyy-mm-dd
/// [int] ms 毫秒
String msFmt(int ms) {
  var date = DateTime.fromMillisecondsSinceEpoch(ms);
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}

/// 影片时长 转换格式
String secFmt(int sec) {
  if (sec <= 0) return "00:00:00";
  var h = sec ~/ 3600;
  var m = sec % 3600 ~/ 60;
  var s = sec % 60;
  var res = h.toString().padLeft(2, '0') +
      ":" +
      m.toString().padLeft(2, '0') +
      ":" +
      s.toString().padLeft(2, '0');
  return res;
}

/// 小视频时长 转换格式
String secFmtEx(int sec) {
  if (sec <= 0) return "00:00";
  var m = sec % 3600 ~/ 60;
  var s = sec % 60;
  var res = m.toString().padLeft(2, '0') + ":" + s.toString().padLeft(2, '0');
  return res;
}

//MARK:转换网络速度
String byteFmt(int by) {
  var res = '0B/S';
  if (by <= 0) return res;

  final f = 1024;
  if (by < f) {
    res = by.toString() + 'B/s';
  } else if (by < f * f) {
    res = (by / f).toStringAsFixed(0) + 'KB/s';
  } else if (by < f * f * f) {
    res = (by / (f * f)).toStringAsFixed(1) + 'MB/s';
  } else {
    res = (by / (f * f * f)).toStringAsFixed(1) + 'GB/s';
  }

  return res;
}

///数字转换为万
String numCoverStr(int num) {
  String followNum;
  if (num >= 10000) {
    String unit = "w";
    double newNum = num / 10000.0;

    followNum = newNum.toStringAsFixed(2) + unit;
  } else {
    followNum = num.toString();
  }
  return followNum;
}

/// 计数转换
String numFmt(int n, {bool cn = false}) {
  var res = '0';
  if (n <= 0) return res;

  var f = cn ? 10000 : 1000;

  if (n < f) {
    res = n.toString();
  } else if (n < f * f) {
    res = (n / f).toStringAsFixed(1) + (cn ? Lang.uWan : 'k');
  } else {
    res = (n / (f * f)).toStringAsFixed(1) + (cn ? Lang.uYi : 'm');
  }

  return res;
}

// // 设备支持震动
// bool _canVibrate;

/// 轻微震动下
Future<void> vibrate() async {
  return await HapticFeedback.lightImpact();

  // if (_canVibrate == null) {
  //   log.d('[VIBRATE] need test can vibrate.');
  //   _canVibrate = await Vibrate.canVibrate;
  // }
  // if (_canVibrate) {
  //   Vibrate.feedback(FeedbackType.impact);
  // }
}

//MARK:--设置状态栏文字颜色白色和背景颜色黑色
void setStatusBarWhiteText(bool flag) {
  FlutterStatusbarcolor.setStatusBarColor(
      flag ? Colors.black : Colors.transparent);
  FlutterStatusbarcolor.setStatusBarWhiteForeground(flag);
}

///*********************vip  start****************************** */

var _vipExpire = '';
var _promotionExpireDate = '';
saveVipInfo(String vipExpire, String promotionExpireDate) {
  var bHasVipData = !(vipExpire == null || vipExpire.isEmpty);
  var bHasVipTempData =
      !(promotionExpireDate == null || promotionExpireDate.isEmpty);
  if (bHasVipData) _vipExpire = vipExpire;
  if (bHasVipTempData) _promotionExpireDate = promotionExpireDate;
}

/// 检查vip 或者推广获取的体验vip是否过期
/// 0 过期 1 显示vip 2显示体验vip
int getVipExpireState() {
  var bHasTempVip =
      !(_promotionExpireDate == null || _promotionExpireDate.isEmpty);
  var bHasVip = !(_vipExpire == null || _vipExpire.isEmpty);

  var now = DateTime.now();
  if (bHasTempVip && bHasVip) {
    var vipD = DateTime.parse(_vipExpire);
    var vipExpire = now.isAfter(vipD);
    if (!vipExpire) {
      return now.isAfter(vipD) ? 0 : 1;
    }
    var vipTempD = DateTime.parse(_promotionExpireDate);
    return now.isAfter(vipTempD) ? 0 : 2;
  }
  if (bHasVip) {
    var vipD = DateTime.parse(_vipExpire);
    return now.isAfter(vipD) ? 0 : 1;
  }
  if (bHasTempVip) {
    var vipTempD = DateTime.parse(_promotionExpireDate);
    return now.isAfter(vipTempD) ? 0 : 2;
  }
  return 0;
}

/// 显示vip过期时间
showVipDateDesc() {
  var s = getVipExpireState();
  if (s == 0) return "";
  if (s == 1)
    return formatDate(
        DateTime.parse(_vipExpire).toLocal(), [yyyy, '-', mm, '-', dd]);
  return formatDate(
      DateTime.parse(_promotionExpireDate).toLocal(), [yyyy, '-', mm, '-', dd]);
}

///*********************vip end****************************** */

///*********************小视频观看缓存数据  start****************************** */
class SvTempCecheData {
  bool isCellect = false;
  bool isLike = false;
}

Map<int, SvTempCecheData> svMapData = {};

checkSvMapData(int id) {
  return svMapData.containsKey(id);
}

SvTempCecheData getSvMapData(id) {
  return svMapData[id];
}

addSvMapData(
    {@required int id, @required bool isCellect, @required bool isLike}) {
  if (!checkSvMapData(id)) {
    svMapData[id] = SvTempCecheData();
  }
  svMapData[id].isCellect = isCellect;
  svMapData[id].isLike = isLike;
}

///*********************小视频观看缓存数据   end****************************** */

/// 获取真实地址
getRealVideoUrl(token, id, videoURL) {
  return hosts.host +
      '/file/m3u8?vId=' +
      '' +
      id.toString() +
      '&token=' +
      token +
      '&name=' +
      videoURL;
}

/// 播放器地址
getVedioUrl(token, id, videoURL) {
  return preInitVideoPlay(getRealVideoUrl(token, id, videoURL));
}

/// 获取短视频真实地址
getRealShortVideoUrl(token, videoURL) {
  return hosts.host +
      '/file/post_m3u8?' +
      '&token=' +
      token +
      '&name=' +
      videoURL;
}

/// 短视频播放器地址
getShortVedioUrl(token, videoURL) {
  return preInitVideoPlay(getRealShortVideoUrl(token, videoURL));
}

/// 获取时间格式�����据
String getDateFmt(String data) {
  var s = DateTime.parse(data).toLocal();
  var y = s.year.toString();
  var m = (s.month + 1).toString();
  var d = s.day.toString();
  var h = s.hour.toString().padLeft(2, "0");
  var min = s.minute.toString().padLeft(2, "0");
  return y + "-" + m + "-" + d + " " + h + ":" + min;
}

var flagColorList = [
  {
    "b": c.cDEF0FD,
    "t": c.c58B4F4,
  },
  {
    "b": c.cFFDEDE,
    "t": c.cFF7676,
  },
  {
    "b": c.cEBDFFF,
    "t": c.c833CFF,
  },
  {
    "b": c.cFFE0D1,
    "t": c.cF77333,
  },
];

/// 获取标签 文字颜色
Map<String, Color> getFlagColors(String str) {
  var m = md5.convert(Uint8List.fromList(utf8.encode(str)));
//  var h = m.bytes.sublist(0, 3).join();
//Endian.little
  //var mm = ByteBuffer.// (m.bytes);

  var mm = Int8List.fromList(m.bytes);
  var bb = ByteData.view(mm.buffer);

  var hash = bb.getInt32(0);
  var index = hash % flagColorList.length;
  return flagColorList[index];
}

bool listEquals<E>(List<E> list1, List<E> list2) {
  if (identical(list1, list2)) {
    return true;
  }
  if (list1 == null || list2 == null) {
    return false;
  }
  final int length = list1.length;
  if (length != list2.length) {
    return false;
  }
  for (int i = 0; i < length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}

///弹出图片查看组件
showPictureSwiper(BuildContext context, List<String> datas, int index) {
  showGeneralDialog(
    // 传入 context
    context: context,
    barrierLabel: "你好",
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 300),
    // 构建 Dialog 的视图
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        Container(
            color: Colors.black,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Center(
                    child: PicturePage(
                      datas: datas,
                      index: index,
                    ),
                  ))
                ],
              ),
            )),
    useRootNavigator: false,
  );
}

//产生随机颜色
List<Color> slRandomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
  if (r == 0 || g == 0 || b == 0) return [Color(0x77000000), Color(0xffffffff)];
//  if (a == 0) return Colors.white;

  var rV = r != 255 ? r : Random.secure().nextInt(r);

  var gV = g != 255 ? g : Random.secure().nextInt(g);

  var bV = g != 255 ? g : Random.secure().nextInt(g);

  return [Color.fromARGB(30, rV, gV, bV), Color.fromARGB(a, rV, gV, bV)];
}

/// 时间戳转时间
DateTime second2DateTime(int sec) {
  return DateTime.fromMicrosecondsSinceEpoch(sec * 1000);
}

/// 图片域名
String _imgDomain = "";
setImgDomain(url) {
  _imgDomain = url;
}

getImgDomain() {
  return _imgDomain;
}

//*********************** 关注列表 start************************ */
/// 关注列表
Map<int, int> watchList = {};
bool checkWatchList(int userId) {
  if (userId == null) return false;
  return watchList.containsKey(userId);
}

addWatchList(int userId) {
  if (userId == null) return;
  if (checkWatchList(userId)) return;
  watchList[userId] = 1;
}

delWatchList(int userId) {
  if (userId == null) return;
  if (!checkWatchList(userId)) return;
  watchList.remove(userId);
}

//*********************** 关注列表 end************************ */

//*********************** 我的数据 start************************ */
MineModel _mineModel;

/// 保存我的数据
saveMineModel(MineModel data) {
  if (data == null) return;
  _mineModel = data;
}

/// 获取我的数据
MineModel getMineModel() {
  return _mineModel;
}

/// 钱包数据
WalletData _walletData;
saveWalletData(WalletData d) {
  _walletData = d;
}

WalletData getWalletData() {
  return _walletData;
}

//*********************** 关注列表 end************************ */

/// 计算index的方法
int computeIndex(
    double _startScrollOffset, double _endScrollOffset, double _maxItemHeight) {
  var scrollRate =
      (_endScrollOffset - _startScrollOffset).abs() / _maxItemHeight;
  if (scrollRate < 0.05) {
    print("滚动停止,滚动距离太小了");
    return -1;
  }

  var endOffsetRate = (_endScrollOffset / _maxItemHeight);

  var modRate = (_endScrollOffset % _maxItemHeight) / _maxItemHeight;

  /// 修正过后的偏移率
  var correctEndOffsetRate = endOffsetRate;
  if (_startScrollOffset < _endScrollOffset) {
    // 向下滑动
    print("move_notify滚动停止向下,滑动量增加了:$scrollRate");
    if (scrollRate <= 0.2 && modRate >= 0.4 && modRate <= 0.6) {
      // 0.4-0.6
      correctEndOffsetRate = endOffsetRate - scrollRate;
    }
  } else {
    // 向上滑动
    print("move_notify滚动停止向上,滑动量减少了$scrollRate");
    if (scrollRate <= 0.2 && modRate >= 0.4 && modRate <= 0.6) {
      //0.6-0.4
      correctEndOffsetRate = endOffsetRate + scrollRate;
    }
  }

  print(
      "move_notify# endOffsetRate:$endOffsetRate correctEndOffsetRate:$correctEndOffsetRate modeRate:$modRate scrollRate:$scrollRate");

  /// 四舍五入
  var index = (correctEndOffsetRate + 0.5).toInt();
  return index;
}
