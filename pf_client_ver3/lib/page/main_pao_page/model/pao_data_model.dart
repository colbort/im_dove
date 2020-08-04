import 'package:app/utils/utils.dart';

/// 泡吧数据
class PaoDataModel {
  /// 帖子编号 帖子唯一标识
  int no;

  /// 用户id
  int userId;

  /// 名称
  String name;

  /// 发布时间
  String date;

  /// 地址 经纬度
  String addr;

  /// 等级
  int lv;

  /// 头像
  String headImg;

  /// 是否关注
  bool bAttention;

  /// 内容
  String content;

  ///是否展开 前端用
  bool bExpand = false;

  /// 标签
  List<String> flagList = [];

  /// 图片列表
  List<String> picList = [];

  /// 视频地址 用于缓存
  String videoURL;

  /// 视频预览Url
  String videoPreviewUrl;

  ///是否播放中 前端用
  bool bPlaying = false;

  ///是否是否初始化完成 前端用
  bool bVideoInited = false;

  /// 是否收藏
  bool isCollect = false;

  /// 是否点赞
  bool isLike = false;

  /// 总收藏数量
  int totalCollect;

  /// 总的点赞数量
  int totalLike;

  /// 总的评论数量
  int totalComment;

  /// 是否购买
  bool isBuy;

  ///类型 1 -> pics    2 -> video
  int typ;

  /// 价格
  int price;

  /// 视频封面
  String videoImg;

  /// 发布状态
  int status;

  bool bSelf = false;

  static PaoDataModel fromJson(Map<String, Object> json) {
    var d = PaoDataModel();
    d.no = json["id"] as int;
    var poster = json["poster"] as Map<String, dynamic>;
    d.userId = 0;
    d.name = "";
    d.headImg = "";
    d.lv = 0;
    d.addr = "";
    if (poster != null) {
      d.userId = poster["id"] as int;
      d.name = poster["name"] as String;
      d.headImg = (poster["pic"] as String) ?? "";
      d.lv = poster["vip"] as int;
      d.addr = (poster["addr"] as String) ?? "";
    }
    d.content = (json["text"] as String) ?? "";
    d.videoImg = json["videoPic"] as String;
    d.videoURL = json["videoUrl"] as String;
    d.videoPreviewUrl = json["videoPreviewUrl"] as String;
    d.picList = (json["pics"] as List)?.map((e) => e.toString())?.toList();
    d.flagList = (json["tags"] as List)?.map((e) => e.toString())?.toList();
    d.price = json["price"] as int;
    d.totalLike = json["likes"] as int;
    d.totalCollect = json["favs"] as int;
    d.totalComment = json["replys"] as int;
    d.bAttention = json["isWatched"] as bool;
    d.isLike = json["isLike"] as bool;
    d.isCollect = json["isFav"] as bool;
    d.isBuy = json["isBuy"] as bool;
    d.typ = json["type"] as int;
    d.date =
        DateTime.fromMillisecondsSinceEpoch((json["createdAt"] as int) * 1000)
            .toString();
    d.status = json["status"] as int;
    if (d.bAttention && d.userId != null) {
      addWatchList(d.userId);
    }
    modifyBuyState(d);
    //json["editorRecommend"] as bool; 编辑推荐
    //json["buys"] as int; 购买数
    return d;
  }

  /// 如果是自己上传的视频 默认购买
  static modifyBuyState(PaoDataModel d) {
    if (d == null) return;
    if (d.isBuy == null) return;
    if (d.isBuy) return;
    if (d.userId == null) return;
    var mineData = getMineModel();
    if (mineData == null || mineData.userId == null) return;
    d.isBuy = mineData.userId == d.userId;
  }

  ///解析搜索结果
  static PaoDataModel fromJsonToSearch(Map<String, Object> json) {
    var d = PaoDataModel();
    d.no = json["id"] as int;
    //var poster = json["poster"] as String;
    // if (poster != null) {
    //   d.userId = poster["id"] as int;
    //   d.name = poster["name"] as String;
    //   d.headImg = (poster["pic"] as String) ?? "";
    //   d.lv = poster["vip"] as int;
    //   d.addr = poster["addr"] as String;
    // }

    d.content = (json["text"] as String) ?? "";
    d.videoImg = json["videoPic"] as String;
    d.videoURL = json["VideoUrl"] as String;
    d.videoPreviewUrl = json["videoPreviewUrl"] as String;
    d.picList = (json["pics"] as List)?.map((e) => e.toString())?.toList();
    d.flagList = (json["tags"] as List)?.map((e) => e.toString())?.toList();
    d.price = json["price"] as int;
    d.totalLike = json["likes"] as int;
    d.totalCollect = json["favs"] as int;
    d.totalComment = json["replys"] as int;
    // d.bAttention = json["isWatched"] as bool;
    // d.isLike = json["isLike"] as bool;
    //  d.isCollect = json["isFav"] as bool;
    //d.isBuy = json["isBuy"] as bool;
    d.isBuy = false;
    //d.date = DateTime.parse((json["createdAt"])).toString();
    d.status = json["status"] as int;
    modifyBuyState(d);
    //json["editorRecommend"] as bool; 编辑推荐
    //json["buys"] as int; 购买数
    return d;
  }
}

List<PaoDataModel> getPaoDataModelList(List<dynamic> list) {
  List<PaoDataModel> result = [];
  if (list == null) return result;
  list.forEach((item) {
    result.add(PaoDataModel.fromJson(item));
  });
  return result;
}

///获取搜索结果数组
List<PaoDataModel> getPaoDataModelListToSearch(List<dynamic> list) {
  List<PaoDataModel> result = [];
  if (list == null) return result;
  list.forEach((item) {
    result.add(PaoDataModel.fromJsonToSearch(item));
  });
  return result;
}
