/// 视频属性
class VideoAttributes {
  bool isVip;
  bool needPay;
  String price;
  int preview;
  bool noLimit;

  VideoAttributes(
      {this.isVip, this.needPay, this.price, this.preview, this.noLimit});

  VideoAttributes.fromJson(Map<String, dynamic> json) {
    isVip = json['isVip'];
    needPay = json['needPay'];
    price = json['price'];
    preview = json['preview'];
    noLimit = json['noLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isVip'] = this.isVip;
    data['needPay'] = this.needPay;
    data['price'] = this.price;
    data['preview'] = this.preview;
    data['noLimit'] = this.noLimit;
    return data;
  }
}
