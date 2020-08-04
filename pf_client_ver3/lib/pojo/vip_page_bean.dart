import 'package:app/pojo/vip_item_bean.dart';

/// 有哪些vip的响应
class VipInfoBean {
  List<VipItemInfo> formal;

  VipInfoBean({this.formal});

  VipInfoBean.fromJson(Map<String, dynamic> json) {
    if (json['formal'] != null) {
      formal = new List<VipItemInfo>();
      json['formal'].forEach((v) {
        formal.add(new VipItemInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.formal != null) {
      data['formal'] = this.formal.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
