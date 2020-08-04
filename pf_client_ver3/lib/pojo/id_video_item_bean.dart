import 'package:app/pojo/video_bean.dart';

/// Video包裹了一层id
class IdVideoItemBean {
  // 如果是收藏=>收藏的id ;如果是购买列表的话是购买id或者交易记录
  int id;
  VideoBean video;
  String createdAt;

  IdVideoItemBean({this.id, this.video, this.createdAt});

  IdVideoItemBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video =
        json['video'] != null ? new VideoBean.fromJson(json['video']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}
