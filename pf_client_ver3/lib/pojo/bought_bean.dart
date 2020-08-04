import 'package:app/pojo/id_video_item_bean.dart';

/// 购买记录的resp
class BoughtBean {
  String domain;
  List<IdVideoItemBean> data;

  BoughtBean({this.domain, this.data});

  BoughtBean.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    if (json['data'] != null) {
      data = new List<IdVideoItemBean>();
      json['data'].forEach((v) {
        data.add(new IdVideoItemBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
