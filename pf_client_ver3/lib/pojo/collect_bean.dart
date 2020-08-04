import 'id_video_item_bean.dart';

/// 收藏记录里面的返回bean
class CollectBean {
  String domain;
  List<IdVideoItemBean> collectRecord;

  CollectBean({this.domain, this.collectRecord});

  CollectBean.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    if (json['collectRecord'] != null) {
      collectRecord = new List<IdVideoItemBean>();
      json['collectRecord'].forEach((v) {
        collectRecord.add(new IdVideoItemBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain'] = this.domain;
    if (this.collectRecord != null) {
      data['collectRecord'] =
          this.collectRecord.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
