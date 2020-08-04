/// 泡吧我的数据
class PaoUserDataModel {
  /// 用户di 用户唯一标识
  int userId;

  /// 名称
  String name;

  /// 性别
  int sex;

  /// 地址
  String addr;

  /// 介绍
  String intro;

  /// 粉丝
  int fans;

  /// 关注
  int watchs;

  /// 封面
  String bgImg;

  /// 头像
  String headImg;

  /// vip
  int vipLv;

  /// 是否关注
  bool bWatch = false;

  static PaoUserDataModel fromJson(Map<String, Object> json) {
    var d = PaoUserDataModel();
    d.userId = json["id"] as int;
    d.headImg = json["logo"] as String;
    d.bgImg = json["bgImg"] as String;
    d.name = json["nickName"] as String;
    d.vipLv = (json["vip"] as int) ?? 0;
    d.sex = json["gender"] as int;
    d.addr = json["addr"] as String;
    d.fans = json["fans"] as int;
    d.watchs = json["watchs"] as int;
    d.intro = json["sign"] as String;
    return d;
  }
}

/// 泡吧评论数据
class PaoCommentModel {
  /// 回复id
  int id;

  /// 用户di 用户唯一标识
  int userId;

  /// 名称
  String name;

  /// 头像
  String headImg;

  /// 内容
  String content;

  /// 类型 1 评论 2回复
  int stype;

  /// 时间
  int date;

  /// 帖子id
  int postId;

  /// 一级评论Id 0 评论了帖子; 非零：回复了我的评论
  int topId;

  /// 点赞数
  int likes;

  /// 是否点赞
  bool isLikes;

  /// vip
  int vipLv;

  /// 经纬度 地址
  String addr;

  /// 性别
  int sex;

  /// 签名 介绍
  String intro;

  static PaoCommentModel fromJson(Map<String, Object> json) {
    var d = PaoCommentModel();
    var replyer = json["replyer"] as Map<String, dynamic>;
    // var bereplyer = json["bereplyer"] as Map<String, dynamic>;
    if (replyer != null) {
      d.userId = replyer["id"] as int;
      d.name = replyer["name"] as String;
      d.headImg = replyer["pic"] as String;
      d.vipLv = replyer["vip"] as int;
      d.addr = replyer["region"] as String;
      d.sex = replyer["gender"] as int;
      d.intro = replyer["sign"] as String;
    }
    d.id = json["id"] as int;
    d.postId = json["postId"] as int;
    d.topId = json["topId"] as int;
    d.content = json["text"] as String;
    d.likes = json["likes"] as int;
    d.isLikes = json["isLikes"] as bool;
    d.date = json["createdAt"] as int;
    d.stype = d.topId == 0 ? 11 : 2;
    return d;
  }
}

List<PaoCommentModel> getPaoCommentModelList(List<dynamic> list) {
  List<PaoCommentModel> result = [];
  if (list == null) return result;
  list.forEach((item) {
    result.add(PaoCommentModel.fromJson(item));
  });
  return result;
}

/// 博主model
class PaoBloggerModel {
  int userId;

  /// 头像
  String headImg;

  /// 名称
  String name;

  /// 1 男 2 女
  int sex;

  /// vip等级
  int vipLv;

  /// 经纬度 地点
  String addr;

  /// 介绍
  String intro;

  /// 是否关注
  bool bWatch = false;

  static PaoBloggerModel fromJson(Map<String, Object> json) {
    var d = PaoBloggerModel();
    d.userId = json["id"] as int;
    d.name = (json["name"] as String) ?? "";
    d.headImg = (json["pic"] as String) ?? "";
    d.vipLv = (json["vip"] as int) ?? 0;
    d.addr = (json["addr"] as String) ?? "";
    d.sex = json["gender"] as int;
    d.intro = (json["sign"] as String) ?? "";
    return d;
  }
}

List<PaoBloggerModel> getPaoBloggerModelList(List<dynamic> list) {
  List<PaoBloggerModel> result = [];
  if (list == null) return result;
  list.forEach((item) {
    result.add(PaoBloggerModel.fromJson(item));
  });
  return result;
}
