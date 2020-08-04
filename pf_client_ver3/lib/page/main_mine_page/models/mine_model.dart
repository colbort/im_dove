class MineModel {
  /// 用户名
  int userId;

  /// 头像
  String logo;

  ///背景
  String bgImg;

  /// vip
  int vipLv;

  /// 观看次数
  int totalWatch;

  /// 剩余下载次数
  int remainDownload;

  /// 推广数量
  int promotion;

  /// av剩余数量
  int avWatchRemain;

  /// 短视频剩余数量
  int shortWatchRemain;

  /// 性别
  int sex;

  /// 是否设置支付码
  bool isSetPayCode = false;

  /// 手机号
  String mobile;

  /// 上级代理码
  String agentCode;

  /// 推广码
  String inviteCode;

  /// 签名
  String sign;

  /// 地址
  String addr;

  /// 粉丝
  int fans;

  /// 关注数量
  int watchs;

  /// 创建时间
  String createAt;

  /// 更新时间
  String updateAt;

  static MineModel fromJson(Map<String, Object> json) {
    if (json == null) return null;
    var d = MineModel();
    d.userId = json["id"] as int;
    d.logo = json["logo"] as String;
    d.bgImg = json["bgImg"] as String;
    d.vipLv = json["level"] as int;
    d.totalWatch = json["totalWatch"] as int;
    d.remainDownload = json["remainDownload"] as int;
    d.promotion = json["promotion"] as int;
    d.avWatchRemain = json["avWatchRemain"] as int;
    d.shortWatchRemain = json["shortWatchRemain"] as int;
    d.sex = json["gender"] as int;
    d.isSetPayCode = json["isSetPayCode"] as bool;
    d.mobile = json["mobile"] as String;
    d.agentCode = json["agentCode"] as String;
    d.inviteCode = json["inviteCode"] as String;
    d.sign = json["sign"] as String;
    d.addr = json["addr"] as String;
    d.fans = json["fans"] as int;
    d.watchs = json["watchs"] as int;
    d.createAt = json["CreateAt"] as String;
    d.updateAt = json["UpdateAt"] as String;

    return d;
  }
}
