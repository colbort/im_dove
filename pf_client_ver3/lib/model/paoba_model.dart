class PaoBa {
  int iId;
  String poster;
  int type;
  String text;
  String videoPic;
  String videoUrl;
  String videoPreviewUrl;
  List<String> pics;
  List<Tags> tags;
  int price;
  int hot;
  int reads;
  int likes;
  int favs;
  int replys;
  int buys;
  int status;
  int editorRecommend;
  String createdAt;
  String publishAt;
  String lastReplyAt;
  String lastBuyAt;
  String uuid;

  PaoBa(
      {this.iId,
      this.poster,
      this.type,
      this.text,
      this.videoPic,
      this.videoUrl,
      this.videoPreviewUrl,
      this.pics,
      this.tags,
      this.price,
      this.hot,
      this.reads,
      this.likes,
      this.favs,
      this.replys,
      this.buys,
      this.status,
      this.editorRecommend,
      this.createdAt,
      this.publishAt,
      this.lastReplyAt,
      this.lastBuyAt,
      this.uuid});

  PaoBa.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    poster = json['poster'];
    type = json['type'];
    text = json['text'];
    videoPic = json['videoPic'];
    videoUrl = json['videoUrl'];
    videoPreviewUrl = json['videoPreviewUrl'];
    pics = json['pics'].cast<String>();
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    price = json['price'];
    hot = json['hot'];
    reads = json['reads'];
    likes = json['likes'];
    favs = json['favs'];
    replys = json['replys'];
    buys = json['buys'];
    status = json['status'];
    editorRecommend = json['editorRecommend'];
    createdAt = json['createdAt'];
    publishAt = json['publishAt'];
    lastReplyAt = json['lastReplyAt'];
    lastBuyAt = json['lastBuyAt'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['poster'] = this.poster;
    data['type'] = this.type;
    data['text'] = this.text;
    data['videoPic'] = this.videoPic;
    data['videoUrl'] = this.videoUrl;
    data['videoPreviewUrl'] = this.videoPreviewUrl;
    data['pics'] = this.pics;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['hot'] = this.hot;
    data['reads'] = this.reads;
    data['likes'] = this.likes;
    data['favs'] = this.favs;
    data['replys'] = this.replys;
    data['buys'] = this.buys;
    data['status'] = this.status;
    data['editorRecommend'] = this.editorRecommend;
    data['createdAt'] = this.createdAt;
    data['publishAt'] = this.publishAt;
    data['lastReplyAt'] = this.lastReplyAt;
    data['lastBuyAt'] = this.lastBuyAt;
    data['uuid'] = this.uuid;
    return data;
  }
}

class Tags {
  String name;

  Tags({this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
