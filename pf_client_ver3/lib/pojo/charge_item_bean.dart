import 'package:app/pojo/pay_type.dart';

/// 单个充值的item
class ChargeItemBean {
  String money;
  List<PayType> types;

  ChargeItemBean({this.money, this.types});

  ChargeItemBean.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    if (json['types'] != null) {
      types = new List<PayType>();
      json['types'].forEach((v) {
        types.add(new PayType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    if (this.types != null) {
      data['types'] = this.types.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
