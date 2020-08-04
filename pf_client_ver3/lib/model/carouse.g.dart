// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Carouse _$CarouseFromJson(Map<String, dynamic> json) {
  return Carouse(
    json['id'] as int,
    json['jumpApp'] as String,
    json['jumpH5'] as String,
    json['linkImg'] as String,
    json['linkName'] as String,
    json['linkType'] as int,
  );
}

Map<String, dynamic> _$CarouseToJson(Carouse instance) => <String, dynamic>{
      'id': instance.id,
      'jumpApp': instance.jumpApp,
      'jumpH5': instance.jumpH5,
      'linkImg': instance.linkImg,
      'linkName': instance.linkName,
      'linkType': instance.linkType,
    };
