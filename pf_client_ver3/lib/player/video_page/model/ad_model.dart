import 'package:json_annotation/json_annotation.dart';

part 'ad_model.g.dart';

@JsonSerializable()
class AdModel {
  AdModel(this.id, this.location, this.img, this.jumpURL, this.status, this.rating, this.startTime, this.endTime,
      this.createdAt, this.updatedAt);

  int id;
  int location; //  投放地址:1-启动页、2-av页、3-短视频页
  String img;
  String jumpURL;

  int status; //  是否启用:1-启用、2-关闭
  int rating;

  String startTime;
  String endTime;
  String createdAt;
  String updatedAt;

  factory AdModel.fromJson(Map<String, dynamic> json) =>
      _$AdModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdModelToJson(this);
}
