import 'package:app/pojo/id_name_bean.dart';
import 'package:app/pojo/video_attrs.dart';

/// 单个视频信息
class VideoBean {
  int id;
  String title;
  String bango;
  int playTime;
  int height;
  int width;
  String preUrl;
  List<IdNameBean> actors; // 女优列表
  VideoAttributes attributes;
  List<String> coverImg;
  int type;
  String reason;
  int star;
  // List<VideoTag> recTags;
  String createdAt;
  int totalWatchTimes;
  int totalRecomTimes;

  /// 自己是否推荐过这部影片
  bool isRecom;

  /// 自己是否已经购买
  bool isBought;

  VideoBean({
    this.id,
    this.title,
    this.bango,
    this.playTime,
    this.height,
    this.width,
    this.preUrl,
    this.actors,
    this.attributes,
    this.coverImg,
    this.type,
    this.reason,
    this.star,
    // this.recTags,
    this.createdAt,
    this.totalWatchTimes,
    this.totalRecomTimes,
    this.isRecom,
    this.isBought,
  });

  VideoBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bango = json['bango'];
    playTime = json['playTime'];
    height = json['height'];
    width = json['width'];
    preUrl = json['preUrl'];
    if (json['actors'] != null) {
      actors = new List<IdNameBean>();
      json['actors'].forEach((v) {
        actors.add(new IdNameBean.fromJson(v));
      });
    }
    attributes = json['attributes'] != null
        ? new VideoAttributes.fromJson(json['attributes'])
        : null;
    coverImg = json['coverImg']?.cast<String>();
    type = json['type'];
    reason = json['reason'];
    star = json['star'];
    // if (json['recTags'] != null) {
    //   recTags = new List<VideoTag>();
    //   json['recTags'].forEach((v) {
    //     recTags.add(new VideoTag.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    totalWatchTimes = json['totalWatchTimes'];
    totalRecomTimes = json['totalRecomTimes'];
    isRecom = json['isRecom'];
    isBought = json['isBought'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['bango'] = this.bango;
    data['playTime'] = this.playTime;
    data['height'] = this.height;
    data['width'] = this.width;
    data['preUrl'] = this.preUrl;
    if (this.actors != null) {
      data['actors'] = this.actors.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    data['coverImg'] = this.coverImg;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['star'] = this.star;
    // if (this.recTags != null) {
    //   data['recTags'] = this.recTags.map((v) => v.toJson()).toList();
    // }
    data['createdAt'] = this.createdAt;
    data['totalWatchTimes'] = this.totalWatchTimes;
    data['totalRecomTimes'] = this.totalRecomTimes;
    data['isRecom'] = this.isRecom;
    data['isBought'] = this.isBought;

    return data;
  }
}
