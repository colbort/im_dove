import 'package:json_annotation/json_annotation.dart';

part 'carouse.g.dart';

List<Carouse> getCarouseList(List<dynamic> list) {
  List<Carouse> result = [];
  list.forEach((item) {
    result.add(Carouse.fromJson(item));
  });
  return result;
}

@JsonSerializable()
class Carouse extends Object {
  @JsonKey(name: 'id')
  int id;

  /// app跳转地址
  @JsonKey(name: 'jumpApp')
  String jumpApp;

  /// h5跳转地址
  @JsonKey(name: 'jumpH5')
  String jumpH5;

  /// 类型 图片地址
  @JsonKey(name: 'linkImg')
  String linkImg;

  /// 名称
  @JsonKey(name: 'linkName')
  String linkName;

  /// 类型 app or h5 or ad
  @JsonKey(name: 'linkType')
  int linkType;

  Carouse(
    this.id,
    this.jumpApp,
    this.jumpH5,
    this.linkImg,
    this.linkName,
    this.linkType,
  );

  static Carouse fromJson(Map<String, dynamic> srcJson) =>
      _$CarouseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CarouseToJson(this);
}
