// import 'package:app/page/set_page/page.dart';
import 'package:fish_redux/fish_redux.dart';

enum VipLevel {
  common,
  expericen,
  month,
  square,
  year,
  lifeLong,
}

/// 我的
class MainMineState implements Cloneable<MainMineState> {
  int shortWatchRemain; // 短视频观影次数
  int avWatchRemain; //AV观影次数
  int totalWatch;
  int remainDownload; // 下载次数
  int promotion; // 推广人数
  String vipExpireDate; //vip到期时间
  /// 推广获取的体验vip到期时间
  String promotionExpireDate;
  String logo;
  String mobile;
  String nickName;
  int gender; // 性别 1，女，2男
  String chatURL; //在线客服url
  int level;
  String inviteCode; //邀请码
  bool isSetPayCode; //是否设置密码
  bool walletUpdate; //钱包交易记录更新

  bool pwChecked;
  String version;
  // String phoneNumber;
  double imageCache;
  bool showAgent; //是否显示全名代理

  @override
  MainMineState clone() {
    return MainMineState()
      ..shortWatchRemain = shortWatchRemain
      ..totalWatch = totalWatch
      ..avWatchRemain = avWatchRemain
      ..remainDownload = remainDownload
      ..promotion = promotion
      ..vipExpireDate = vipExpireDate
      ..promotionExpireDate = promotionExpireDate
      ..logo = logo
      ..mobile = mobile
      ..nickName = nickName
      ..gender = gender
      ..chatURL = chatURL
      ..level = level
      ..inviteCode = inviteCode
      ..isSetPayCode = isSetPayCode
      ..walletUpdate = walletUpdate
      ..version = version
      ..pwChecked = pwChecked
      // ..phoneNumber = mobile
      ..imageCache = imageCache
      ..showAgent = showAgent;
  }
}

MainMineState initState(Map<String, dynamic> args) {
  return MainMineState()
    ..shortWatchRemain = 0
    ..avWatchRemain = 0
    ..totalWatch = 0
    ..remainDownload = 0
    ..promotion = 0
    ..vipExpireDate = null
    ..logo = ''
    ..mobile = ''
    ..nickName = ''
    ..gender = 1
    ..chatURL = null
    ..level = 0
    ..isSetPayCode = false
    ..inviteCode = null
    ..walletUpdate = false
    ..pwChecked = false
    ..version = ''
    ..imageCache = 0
    ..showAgent = false;
}
