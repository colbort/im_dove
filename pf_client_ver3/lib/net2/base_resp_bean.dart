/// 基础网络请求结构
/// 本来是业务层包装的一层东西，但是这个项目好像没用，用状态码代替了业务码
class BaseRespBean<T> {
  int code;
  T data;
  String tips;
  String action;

  BaseRespBean(this.code, {this.data, this.tips, this.action});

  BaseRespBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    tips = json['tips'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    data['tips'] = this.tips;
    data['action'] = this.action;
    return data;
  }
}
