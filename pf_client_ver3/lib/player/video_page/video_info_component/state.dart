import 'package:app/player/video_page/model/ad_model.dart';
import 'package:app/player/video_page/model/attributes.dart';
import 'package:app/player/video_page/model/video_model.dart';
import 'package:fish_redux/fish_redux.dart';

class VideoWarp {
  ///MARK:视频id
  int id;

  ///MARK:标题
  String title;

  //影片时长
  int playTime = 0;

  //MARK:视频属性
  Attributes attributes;

  ///MARK:图片地址
  List<String> coverImgList;

  ///MARK:总观看次数
  int totalWatchTimes;

  ///MARK:标签列表
  List tagList;

  ///MARK:创建时间
  List actors;

  ///MARK:标题
  String bango;

  //是否已购买
  bool isBought;
}

class VideoInfoState implements Cloneable<VideoInfoState> {
  int videoId;
  String videoTitle = '...';
  String coverUrl;
  //影片时长
  int playTime = 0;
  //观看次数
  int videoWatch = 0;
  //点赞数量
  int likes = 0;
  //自己是否点赞
  bool isLike = false;
  //点踩数量
  int unlikes = 0;
  //自己是否点踩了
  bool isUnlike = false;
  //是否是否收藏了
  bool isFavorite = false;
  bool canWatch = true;
  int reason = 0;
  String price;
  double wallet = 0;
  //推荐列表
  List<VideoWarp> recommendVideoList = [];
  //这里还是保留原有视频模型
  VideoModel videoModel;
  //MARK:视频属性
  Attributes attributes;
  //广告
  List<AdModel> adModels = [];
  //动画重制参数，只有第一次build为true
  bool snapToEnd = true;

  @override
  VideoInfoState clone() {
    return VideoInfoState()
      ..videoId = videoId
      ..videoTitle = videoTitle
      ..coverUrl = coverUrl
      ..playTime = playTime
      ..videoWatch = videoWatch
      ..likes = likes
      ..isLike = isLike
      ..unlikes = unlikes
      ..isUnlike = isUnlike
      ..isFavorite = isFavorite
      ..canWatch = canWatch
      ..reason = reason
      ..price = price
      ..wallet = wallet
      ..recommendVideoList = recommendVideoList
      ..videoModel = videoModel
      ..attributes = attributes
      ..adModels = adModels
      ..snapToEnd = snapToEnd;
  }
}
