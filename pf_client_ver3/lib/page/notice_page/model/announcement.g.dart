// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) {
  return Announcement(
    json['content'] as String,
    json['createAt'] as String,
    json['creator'] as String,
    json['name'] as String,
    json['offline'] as String,
    json['releaseTime'] as String,
    json['status'] as bool,
    json['title'] as String,
  );
}

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'content': instance.content,
      'createAt': instance.createAt,
      'creator': instance.creator,
      'name': instance.name,
      'offline': instance.offline,
      'releaseTime': instance.releaseTime,
      'status': instance.status,
      'title': instance.title,
    };
