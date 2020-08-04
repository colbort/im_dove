import 'package:json_annotation/json_annotation.dart';

import 'attributes.dart';

part 'search_final_resp.g.dart';

@JsonSerializable()
class SearchFinalResp extends Object {
  @JsonKey(name: 'domain')
  String domain;

  @JsonKey(name: 'searchResp')
  List<SearchResp> searchResp;

  SearchFinalResp(
    this.domain,
    this.searchResp,
  );

  static SearchFinalResp fromJson(Map<String, dynamic> srcJson) =>
      _$SearchFinalRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchFinalRespToJson(this);
}

@JsonSerializable()
class SearchResp extends Object {
  @JsonKey(name: 'createdAt')
  String createdAt;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'totalWatchTimes')
  int totalWatchTimes;

  @JsonKey(name: 'video')
  VideoBase video;

  @JsonKey(name: 'actors')
  List<Map> actors;

  @JsonKey(name: 'tags')
  List tags;
  @JsonKey(name: 'isCollect')
  bool isCollect;

  @JsonKey(name: 'isLike')
  bool isLike;

  @JsonKey(name: 'isUnLike')
  bool isUnLike;
  @JsonKey(name: 'totalLikes')
  int totalLikes;

  @JsonKey(name: 'totalComments')
  int totalComments;

  @JsonKey(name: 'totalUnLikes')
  int totalUnLikes;

  SearchResp(
    this.createdAt,
    this.id,
    this.totalWatchTimes,
    this.video,
    this.actors,
    this.tags,
    this.isCollect,
    this.isLike,
    this.isUnLike,
    this.totalLikes,
    this.totalComments,
    this.totalUnLikes,
  );

  static SearchResp fromJson(Map<String, dynamic> srcJson) =>
      _$SearchRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchRespToJson(this);
}

@JsonSerializable()
class VideoBase extends Object {
  /// 视频id
  @JsonKey(name: 'coverImg')
  List<String> coverImg;

  @JsonKey(name: 'id')
  int id;

  /// 时长
  @JsonKey(name: 'playTime')
  int playTime;

  /// 视频标题
  @JsonKey(name: 'title')
  String title;

  /// 女优封面
  @JsonKey(name: 'actorImg')
  String actorImg;

  @JsonKey(name: 'attributes')
  Attributes attributes;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'actors')
  List actors;

  /// 女优封面
  @JsonKey(name: 'bango')
  String bango;

  /// 视频地址
  @JsonKey(name: 'videoURL')
  String videoURL;

  ///
  @JsonKey(name: 'totalWatchTimes')
  int totalWatchTimes;

  VideoBase(
    this.coverImg,
    this.id,
    this.playTime,
    this.title,
    this.actorImg,
    this.attributes,
    this.height,
    this.width,
    this.actors,
    this.bango,
    this.videoURL,
    this.totalWatchTimes,
  );

  static VideoBase fromJson(Map<String, dynamic> srcJson) =>
      _$VideoBaseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoBaseToJson(this);
}
