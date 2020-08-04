/// 支付成功的bean
/// <pre>{
//     "openNewBrowser": true,
//     "url": "https://pace.meketrip.com/pay_cjg.html?oid=WW2020022723195148040880&sign=a26788d860369ec8463d78341f0ede9d&t=1582816791495&a=https%3A%2F%2Fnail.yulirobot.com"
// }
/// </pre>
class PaySucBean {
  bool openNewBrowser;
  String url;

  PaySucBean({this.openNewBrowser, this.url});

  PaySucBean.fromJson(Map<String, dynamic> json) {
    openNewBrowser = json['openNewBrowser'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['openNewBrowser'] = this.openNewBrowser;
    data['url'] = this.url;
    return data;
  }
}
