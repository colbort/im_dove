/// 简单的id和名称标签
class IdNameBean {
  int id;
  String name;

  IdNameBean({this.id, this.name});

  IdNameBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
