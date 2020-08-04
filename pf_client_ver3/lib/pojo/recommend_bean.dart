import 'package:app/pojo/video_bean.dart';

const int RECOMMAND_TYPE_GUANFANG = 0;
const int RECOMMAND_TYPE_PAOYOU = 100;
const int RECOMMAND_TYPE_BANGDAN = 101;

class RecommendBean {
  String domain;
  List<VideoBean> videos;

  RecommendBean({this.domain, this.videos});

  RecommendBean.fromJson(Map<String, dynamic> json) {
    domain = json['domain'];
    if (json['videos'] != null) {
      videos = new List<VideoBean>();
      json['videos'].forEach((v) {
        videos.add(new VideoBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['domain'] = this.domain;
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
