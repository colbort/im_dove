import 'package:app/net/net.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/pojo/bought_bean.dart';
import 'package:app/pojo/charge_item_bean.dart';
import 'package:app/pojo/collect_bean.dart';
import 'package:app/pojo/pay_suc_bean.dart';
import 'package:app/pojo/recommend_bean.dart';
import 'package:app/pojo/version_bean.dart';
import 'package:app/pojo/vip_page_bean.dart';
import 'package:app/utils/comm.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'client_api.g.dart';

@RestApi()
abstract class ClientApi {
  factory ClientApi(Dio dio, {String baseUrl}) = _ClientApi;

  /// 获取首页推荐数据
  /// [type]
  /// const int RECOMMAND_TYPE_GUANFANG = 0;
  /// const int RECOMMAND_TYPE_PAOYOU = 100;
  /// const int RECOMMAND_TYPE_BANGDAN = 101;
  @POST("/recommend/av")
  Future<RecommendBean> getRecommendData(
      @Field('id') int type, @Field() int page,
      [@Field() int pageSize = 30]);

  @POST("/v3/video/categoryVideoHome")
  Future<ClassifyHome> getClassifyHome([
    @Field() int sortId = 0,
    @Field() int categoryId = 0,
    @Field() int tagId = 0,
    @Field('page_size') int pageSize = PAGE_SIZE,
  ]);

  @POST("/v3/video/categoryVideo")
  Future<VideosBean> getClassifyNext(
      @Field() int sortId, @Field() int categoryId, @Field() int tagId,
      [@Field() int skip = 0, @Field() int limit = PAGE_SIZE]);

  /// 获取AV精选获取轮播图
  @POST("/carouse/list")
  Future<List<CarouseBean>> getSelectedCarousel([@Field() int type = 3]);

  /// 获取AV精选专区的所有的组
  @POST("/v3/video/allTopicVideo")
  Future<VideoGroupsBean> getSelectedGroups();

  /// 获取AV精选专区的换一换
  @POST("/v3/video/topicVideo")
  Future<VideoGroupBean> getSelectedGroup(@Field() int topicId);

  ///获取系统可用版本
  @POST(Routers.VERSION_GETVERSION_POST)
  Future<VersionBean> getVersion(
    @Body() Map<String, dynamic> map2,
  );

  /// 获取AV金币专区的视频内容
  @POST('/video/needPayVideos')
  Future<VideosBean> getCoinVideos(@Field() int page,
      [@Field() int pageSize = PAGE_SIZE]);

  /// 获取已经购买了的视频
  @POST("/video/avBuysNew")
  Future<BoughtBean> getBoughtVideos(@Field() int skip,
      [@Field() int limit = PAGE_SIZE]);

  /// 获取已经收藏的视频
  @POST("/userVideo/avCollectsNew")
  Future<CollectBean> getCollectVideos(@Field() int skip,
      [@Field() int limit = PAGE_SIZE]);

  /// 获取支付类型
  @GET("/recharge/paytype")
  Future<List<ChargeItemBean>> getPayType();

  /// 开始支付，其实应该是创建订单
  /// [payType]支付类型: 0:余额购买vip/泡花, 1:alipay(支付宝), 2:unionpay(银联), 3:weipay(微信)
  /// [paySign] one of this = 'fixedAlipay'; ='fixedWechat'; = 'union';
  /// [buyType] 购买类型/充值用途: 1--常规充值(余额) 2--购买vip 3--购买泡花
  /// [cardId] 如果typ == 2 传入会员卡的卡的id
  @POST("/recharge/submit")
  Future<PaySucBean> pay(@Field() double money, @Field() int payType,
      @Field("typeName") String paySign, @Field("typ") int buyType,
      [@Field("id") int cardId = 0, @Field() bool flag = true]);

  /// 获取所有充值会员的信息
  @GET(Routers.VIP_GETALLLIST_GET)
  Future<VipInfoBean> getAllVipInfo();
}
