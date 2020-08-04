/// 单个要充值的vip信息
class VipItemInfo {
  int cardId;
  int cardType;
  int vipLevel;
  String title;
  String subTitle;
  String paoHua;
  String money;
  String paoHuaPrePrice;
  String moneyPrePrice; //折后价，如果有
  int dayCount;
  int downCount;
  int status;
  String desc;

  VipItemInfo(
      {this.cardId,
      this.cardType,
      this.vipLevel,
      this.title,
      this.subTitle,
      this.paoHua,
      this.money,
      this.paoHuaPrePrice,
      this.moneyPrePrice,
      this.dayCount,
      this.downCount,
      this.status,
      this.desc});

  VipItemInfo.fromJson(Map<String, dynamic> json) {
    cardId = json['cardId'];
    cardType = json['cardType'];
    vipLevel = json['vipLevel'];
    title = json['title'];
    subTitle = json['subTitle'];
    paoHua = json['paoHua'];
    money = json['money'];
    paoHuaPrePrice = json['paoHuaPrePrice'];
    moneyPrePrice = json['moneyPrePrice'];
    dayCount = json['dayCount'];
    downCount = json['downCount'];
    status = json['status'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardId'] = this.cardId;
    data['cardType'] = this.cardType;
    data['vipLevel'] = this.vipLevel;
    data['title'] = this.title;
    data['subTitle'] = this.subTitle;
    data['paoHua'] = this.paoHua;
    data['money'] = this.money;
    data['paoHuaPrePrice'] = this.paoHuaPrePrice;
    data['moneyPrePrice'] = this.moneyPrePrice;
    data['dayCount'] = this.dayCount;
    data['downCount'] = this.downCount;
    data['status'] = this.status;
    data['desc'] = this.desc;
    return data;
  }
}
