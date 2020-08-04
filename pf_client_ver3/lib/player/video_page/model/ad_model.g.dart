// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdModel _$AdModelFromJson(Map<String, dynamic> json) {
  return AdModel(
    json['id'] as int,
    json['location'] as int,
    json['img'] as String,
    json['jumpURL'] as String,
    json['status'] as int,
    json['rating'] as int,
    json['startTime'] as String,
    json['endTime'] as String,
    json['createdAt'] as String,
    json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$AdModelToJson(AdModel instance) => <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'img': instance.img,
      'jumpURL': instance.jumpURL,
      'status': instance.status,
      'rating': instance.rating,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
