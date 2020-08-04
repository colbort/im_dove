import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement extends Object {
  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'createAt')
  String createAt;

  @JsonKey(name: 'creator')
  String creator;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'offline')
  String offline;

  @JsonKey(name: 'releaseTime')
  String releaseTime;

  @JsonKey(name: 'status')
  bool status;

  @JsonKey(name: 'title')
  String title;

  Announcement(
    this.content,
    this.createAt,
    this.creator,
    this.name,
    this.offline,
    this.releaseTime,
    this.status,
    this.title,
  );

  static Announcement fromJson(Map<String, dynamic> srcJson) =>
      _$AnnouncementFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
