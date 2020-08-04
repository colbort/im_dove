class VersionBean {
  int id;
  String versionNum;
  String terminal;
  String link;
  String info;
  int packageType;
  bool isForceUpdate;
  bool status;
  String size;
  String createdAt;
  String updatedAt;

  VersionBean(
      {this.id,
      this.versionNum,
      this.terminal,
      this.link,
      this.info,
      this.packageType,
      this.isForceUpdate,
      this.status,
      this.size,
      this.createdAt,
      this.updatedAt});

  VersionBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    versionNum = json['versionNum'];
    terminal = json['terminal'];
    link = json['link'];
    info = json['info'];
    packageType = json['packageType'];
    isForceUpdate = json['isForceUpdate'];
    status = json['status'];
    size = json['size'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['versionNum'] = this.versionNum;
    data['terminal'] = this.terminal;
    data['link'] = this.link;
    data['info'] = this.info;
    data['packageType'] = this.packageType;
    data['isForceUpdate'] = this.isForceUpdate;
    data['status'] = this.status;
    data['size'] = this.size;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
