import 'package:app/net/net.dart';
import 'package:app/player/video_page/model/ad_model.dart';
import 'package:app/utils/hosts.dart';
import 'video.dart';

///CLASS: 视频模型
class VideoModel {
  int videoId;

  ///MARK:是否点赞
  bool isLike;

  ///MARK:是否不感兴趣
  bool isUnLike;

  ///MARK:是否收藏
  bool isCollect;

  ///MARK:视频
  Video video;

  ///MARK:视频域名(暂时不用)
  String videoDomain;

  ///MARK:其他域名
  String domain;

  bool canWatch;

  // ///MARK:可能喜欢视频列表
  // List<Video> recommendVideoList;

  /// av广告
  List<AdModel> adModels = [];
  int reason;

  /// 钱包余额
  String balance;
  VideoModel({
    this.videoId,
    this.isLike = false,
    this.isUnLike = false,
    this.isCollect = false,
    this.canWatch = true,
    this.video,
    this.videoDomain,
    this.domain,
    // this.recommendVideoList = const [],
    this.reason,
    this.balance,
  });

  VideoModel.fromJson(String token, Map<String, dynamic> json) {
    isLike = json['isLike'];
    isUnLike = json['isUnLike'];
    isCollect = json['isCollect'];
    videoDomain = json['videoDomain'];
    canWatch = json['canWatch'];
    videoId = json['videoId'];
    domain = json['domain'];
    //MARK:获取baseDomain
    var url = hosts.host + Routers.FILE_M3U8;
    video = Video.fromJson(url, domain, token, json['video']);

    // recommendVideoList = List.from(json['maybeLike']).map((e) {
    //   int id = e['id'];
    //   String title = e['title'];
    //   int playTime = e['playTime'];
    //   List actors = e['actors'];
    //   List tags = e['tags'];
    //   int totalWatchTimes = e['totalWatchTimes'];
    //   var coverImgList = List.from(e['coverImg']).map((e) {
    //     var result = domain;
    //     if (!result.endsWith('/')) {
    //       result += '/';
    //     }
    //     return result += e;
    //   }).toList();
    //   String bango = e['bango'];
    //   return Video(
    //     id: id,
    //     title: title,
    //     coverImgList: coverImgList,
    //     playTime: playTime,
    //     tagList: tags,
    //     totalWatchTimes: totalWatchTimes,
    //     actors: actors,
    //     bango: bango,
    //     attributes: Attributes.fromJson(e['attributes']),
    //   );
    // }).toList();
    reason = json['reason'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isLike'] = this.isLike;
    data['videoId'] = this.videoId;
    data['isUnLike'] = this.isUnLike;
    data['isCollect'] = this.isCollect;
    data['video'] = this.video.toJson();
    data['videoDomain'] = this.videoDomain;
    data['domain'] = this.domain;
    // data['maybeLike'] = this.recommendVideoList;
    data['reason'] = this.reason;
    data['balance'] = this.balance;
    return data;
  }
}
