class UserInfoModel {
  /// id
  int userId;

  /// 头像
  String portrait;

  /// 名称
  String userName;

  /// 性别
  int sex;

  /// 地址
  String addr;

  /// vip
  int vipLv;

  static UserInfoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserInfoModel userInfoModel = UserInfoModel();
    userInfoModel.userId = map['id'];
    userInfoModel.portrait = map['pic'];
    userInfoModel.userName = map['name'];
    userInfoModel.sex = map['gender'];
    userInfoModel.addr = map['addr'];
    userInfoModel.vipLv = map['vip'];
    return userInfoModel;
  }

  Map<String, dynamic> toJson() => {
        "id": userId,
        "pic": portrait,
        "name": userName,
        "gender": sex,
        "addr": addr,
        "vip": vipLv,
      };
}
