// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_final_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFinalResp _$SearchFinalRespFromJson(Map<String, dynamic> json) {
  return SearchFinalResp(
    json['domain'] as String,
    (json['searchResp'] as List)
        ?.map((e) =>
            e == null ? null : SearchResp.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchFinalRespToJson(SearchFinalResp instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'searchResp': instance.searchResp,
    };

SearchResp _$SearchRespFromJson(Map<String, dynamic> json) {
  return SearchResp(
    json['createdAt'] as String,
    json['id'] as int,
    json['totalWatchTimes'] as int,
    json['video'] == null
        ? null
        : VideoBase.fromJson(json['video'] as Map<String, dynamic>),
    (json['actors'] as List)?.map((e) => e as Map<String, dynamic>)?.toList(),
    json['tags'] as List,
    json['isCollect'] as bool,
    json['isLike'] as bool,
    json['isUnLike'] as bool,
    json['totalLikes'] as int,
    json['totalComments'] as int,
    json['totalUnLikes'] as int,
  );
}

Map<String, dynamic> _$SearchRespToJson(SearchResp instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'id': instance.id,
      'totalWatchTimes': instance.totalWatchTimes,
      'video': instance.video,
      'actors': instance.actors,
      'tags': instance.tags,
      'isCollect': instance.isCollect,
      'isLike': instance.isLike,
      'isUnLike': instance.isUnLike,
      'totalLikes': instance.totalLikes,
      'totalComments': instance.totalComments,
      'totalUnLikes': instance.totalUnLikes,
    };

VideoBase _$VideoBaseFromJson(Map<String, dynamic> json) {
  return VideoBase(
    (json['coverImg'] as List)?.map((e) => e as String)?.toList(),
    json['id'] as int,
    json['playTime'] as int,
    json['title'] as String,
    json['actorImg'] as String,
    json['attributes'] == null
        ? null
        : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    json['height'] as int,
    json['width'] as int,
    json['actors'] as List,
    json['bango'] as String,
    json['videoURL'] as String,
    json['totalWatchTimes'] as int,
  );
}

Map<String, dynamic> _$VideoBaseToJson(VideoBase instance) => <String, dynamic>{
      'coverImg': instance.coverImg,
      'id': instance.id,
      'playTime': instance.playTime,
      'title': instance.title,
      'actorImg': instance.actorImg,
      'attributes': instance.attributes,
      'height': instance.height,
      'width': instance.width,
      'actors': instance.actors,
      'bango': instance.bango,
      'videoURL': instance.videoURL,
      'totalWatchTimes': instance.totalWatchTimes,
    };
