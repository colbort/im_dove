import 'package:json_annotation/json_annotation.dart';

part 'attributes.g.dart';

@JsonSerializable()
class Attributes extends Object {
  @JsonKey(name: 'isVip')
  bool isVip;

  @JsonKey(name: 'needPay')
  bool needPay;

  @JsonKey(name: 'noLimit')
  bool noLimit;

  @JsonKey(name: 'preview')
  int preview;

  @JsonKey(name: 'price')
  String price;

  Attributes(
    this.isVip,
    this.needPay,
    this.noLimit,
    this.preview,
    this.price,
  );

  static Attributes fromJson(Map<String, dynamic> srcJson) =>
      _$AttributesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
