// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attributes _$AttributesFromJson(Map<String, dynamic> json) {
  return Attributes(
    json['isVip'] as bool,
    json['needPay'] as bool,
    json['noLimit'] as bool,
    json['preview'] as int,
    json['price'] as String,
  );
}

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'isVip': instance.isVip,
      'needPay': instance.needPay,
      'noLimit': instance.noLimit,
      'preview': instance.preview,
      'price': instance.price,
    };
