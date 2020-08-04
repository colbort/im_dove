import 'package:app/loc_server/vedio_data.dart';
import 'package:app/player/video_page/model/attributes.dart';

///CLASS:视频类型 av==1 video==2
enum VideoType { av, video }

///CLASS:视频模型
class Video {
  ///MARK:视频id
  int id;

  ///MARK:标题
  String title;

  ///MARK:视频类型
  VideoType type;

  ///MARK:影片时长
  int playTime;

  /// 播放进度
  Duration proccessTime = Duration.zero;

  ///MARK:图片地址
  List<String> coverImgList;

  ///MARK:播放地址
  String videoUrl;

  ///MARK:总观看次数
  int totalWatchTimes;

  ///MARK:总点赞数
  int totalLikes;

  ///MARK:总不感兴趣数
  int totalUnLikes;

  ///MARK:标签列表
  List tagList;

  ///MARK:创建时间
  DateTime createdAt;

  ///MARK:创建时间
  List actors;

  ///MARK:标题
  String bango;

  //MARK:视频属性
  Attributes attributes;

  //是否已经付费了
  bool isBought;

  Video({
    this.id,
    this.title = '',
    this.type = VideoType.av,
    this.playTime = 0,
    this.proccessTime = Duration.zero,
    this.coverImgList = const [],
    this.videoUrl,
    this.totalWatchTimes = 0,
    this.totalLikes = 0,
    this.totalUnLikes = 0,
    this.tagList,
    this.createdAt,
    this.actors,
    this.bango,
    this.attributes,
    this.isBought = false,
  });

  Video.fromJson(String baseDomain, String imgDomain, String token,
      Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    title = jsonData['title'];
    isBought = jsonData['isBought'] ?? false;
    type = VideoType.values[jsonData['type'] - 1];
    playTime = jsonData['playTime'];
    proccessTime = jsonData['proccessTime'];
    coverImgList = List<String>.from(jsonData['coverImg'])
        .map((e) => imgDomain + '/' + e)
        .toList();
    String originUrl = baseDomain +
        '?vId=' +
        '$id' +
        '&token=' +
        token +
        '&name=' +
        jsonData['videoURL'];

    videoUrl = preInitVideoPlay(originUrl);
    totalWatchTimes = jsonData['totalWatchTimes'];
    totalLikes = jsonData['totalLikes'];
    totalUnLikes = jsonData['totalUnLikes'];
    tagList = List.from(jsonData['tags']).map((e) {
      int id = e['id'];
      String name = e['name'];
      return Tags(id: id, name: name);
    }).toList();
    actors = jsonData['actors'];
    createdAt = DateTime.parse(jsonData['createdAt']).toLocal();
    attributes = Attributes.fromJson(jsonData['attributes']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['isBought'] = this.isBought;
    data['type'] = this.type;
    data['playTime'] = this.playTime;
    data['proccessTime'] = this.proccessTime.inSeconds;
    data['coverImg'] = this.coverImgList;
    data['videoURL'] = this.videoUrl;
    data['totalWatchTimes'] = this.totalWatchTimes;
    data['totalLikes'] = this.totalLikes;
    data['totalUnLikes'] = this.totalUnLikes;
    data['tags'] = this.tagList;
    data['createAt'] = this.createdAt;
    data['actors'] = this.actors;
    data['attributes'] = this.attributes.toJson();
    return data;
  }
}

class Tags {
  Tags({this.id, this.name});
  int id;
  String name;
}
