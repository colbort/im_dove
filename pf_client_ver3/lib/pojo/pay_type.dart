/// 支付类型
/// <pre>
//  {
//                 "name": "银联",
//                 "payMent": "1003",
//                 "type": "union"
//             }
///
/// </pre>
class PayType {
  String name;
  String payMent;
  String type; // one of PAYTYPE

  PayType({this.name, this.payMent, this.type});

  PayType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    payMent = json['payMent'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['payMent'] = this.payMent;
    data['type'] = this.type;
    return data;
  }
}
