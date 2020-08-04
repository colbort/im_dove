///地址数据
class Routers {
  /// 选线域名
  static const URL_LIST = [
    "https://pfapi1.com",
    "https://pfapi2.com",
    "https://pfapi3.com",
    "https://pfapi4.com",
  ];

  /// api 地址
  static const API_Url = "/api";

  /// 选线地址
  static const STAT_Url = "/api/srv/stat";
  // static const  _GET = "GET";
  // static const  _POST = "POST";
  static const BASE_URL = "https://api.whuzxw.com/api";
  // static const  BASE_URL = "https://sza.16jsjgj.com/api";
  // static const  BASE_URL = "http://192.168.1.2:8088/api";

  /// 游客登陆
  static const USER_TRAVELER = "/user/traveler";

  /// 上传用户操作
  static const USEROPERA_ADD = "/userOpera/add";

  /// 获取动作
  static const USER_MOBILE_ACTION = "/user/mobileAction";

  /// 获取验证码
  static const USER_CAPTCHA = "/user/captcha";

  /// 绑定手机号码
  static const USER_BIND = "/user/bind";

  /// 被踢号后重新登录
  static const USER_RELOGIN = "/user/offical";

  ///新增活动
  ///参数：ActivityInfo
  ///返回：
  static const ACTIVITY_ADD_POST = "/activity/add";

  ///删除活动
  /// 参数：name
  /// 返回：
  static const ACTIVITY_DEL_POST = "/activity/del";

  ///编辑活动
  ///参数：ActivityInfo
  ///返回：
  static const ACTIVITY_EDIT_POST = "/activity/edit";

  ///查询活动
  ///参数：无
  ///返回：ActivityInfo
  static const ACTIVITY_QUERY_GET = "/activity/query";

  ///搜索活动
  ///参数：name
  ///返回：ActivityInfo
  static const ACTIVITY_SEARCH_GET = "/activity/search";

  ///查询所有广告
  ///参数：location:标签id
  ///返回：AppAdResp
  static const AD_APPADS_POST = "/ad/appAds";

  ///记录类型 1广告、2视频、3轮播点击次数
  ///参数：AdCount
  ///返回：bool
  static const AD_COUNTAD_POST = "/ad/countAd";

  ///创建一条公告
  ///参数：AnnouncementReq
  ///返回：
  static const ANN_CREATE_POST = "/ann/create";

  ///获取全部公告
  ///参数：startTime:开始时间;  endTime:结束时间;  name:;  pageIndex:分页索引; pageSize:分页size 默认20
  ///返回：GetAllAnnRes
  static const ANN_FINDALLHISTORY_GET = "/ann/findAllHistory";

  ///获取最近的一条公告
  ///参数：无
  ///返回：Announcement
  static const ANN_GETLATELYHISTORY_GET = "/ann/getLatelyHistory";

  ///更新一条公告
  ///参数：AnnouncementReq
  ///返回：
  static const ANN_UPDATE_POST = "/ann/update";

  ///在线客服签名 client请求接入客户时，需签名通过，返回聊天的url
  ///参数：SignInfo
  ///返回：SignRes
  static const CHAT_SIGN_POST = "/chat/sign";

  ///轮播列表
  ///参数：无
  ///返回：[Carouse]
  static const CAROUSE_LIST_POST = "/carouse/list";

  ///可用域名列表
  ///参数：无
  ///返回：[Domain]
  static const DOMAIN_LIST_POST = "/domain/list";

  ///根据page查询充值记录 client请求获取充值记录数据,etc:skip=0&limit=3，跳过0页，取3条数据
  ///参数：Page
  ///返回：[RechargeRecordInfo]
  static const RECHARGE_PAGE_POST = "/recharge/page";

  ///通知client充值成功
  ///参数：GoldfishResultRes
  ///返回：
  static const RECHARGE_REPONSE_POST = "/recharge/response";

  ///client充值请求,返回充值链接
  ///参数：ClientReq
  ///返回：
  static const RECHARGE_SUBMIT_POST = "/recharge/submit";

  ///查询可充值区间
  static const RECHARGE_SELECT_POST = "/recharge/select";

  ///编辑任务
  ///参数：TaskInfo
  ///返回：
  static const TASK_EDIT_POST = "/task/edit";

  ///查询任务
  ///参数：无
  ///返回：[TaskStruct]
  static const TASK_QUERY_GET = "/task/query";

  ///任务状态 任务完成时，更新任务的状态
  ///参数：TaskInfo
  ///返回：
  static const TASK_STATE_POST = "/task/state";

  ///app端查询演员列表 用户点赞、踩、收藏的操作接口
  ///参数：UserVideoReq
  ///返回：无
  static const USERVIDEO_ADDRECORD_POST = "/userVideo/addRecord";

  ///观影记录操作
  ///参数：AddWrReq
  ///返回：无
  static const USERVIDEO_ADDWATCHRECORD_POST = "/userVideo/addWatchRecord";

  ///个人收藏列表
  ///参数：avCollectsReq
  ///返回：CrFinalResp
  static const USERVIDEO_AVCOLLECTS_POST = "/userVideo/avCollects";

  ///短视频个人收藏列表
  ///参数：spCollectsReq
  ///返回：CrFinalResp
  static const USERVIDEO_SPCOLLECTS_POST = "/userVideo/spCollects";

  ///用户取消点赞、踩、收藏的操作接口
  ///参数：DeleteUvReq
  ///返回：无
  static const USERVIDEO_DELETERECORD_POST = "/userVideo/deleteRecord";

  ///获取剩余观影次数和下载次数
  ///参数：无
  ///返回：WatchsDownLoadsResp
  static const USERVIDEO_GETRAMINWATCHS_POST = "/userVideo/getRaminWatchs";

  ///获取剩余观影次数和下载次数
  ///参数：videoId 视频id
  ///返回：无
  static const USERVIDEO_UPDATEDOWNLOADS_POST = "/userVideo/updateDownloads";

  ///个人观影记录
  ///参数：WatchRecordReq
  ///返回：WatchRecordResp
  static const USERVIDEO_WATCHRECORD_POST = "/userVideo/watchRecord";

  ///Version版本接口
  ///参数：VersionRq
  ///返回：Version
  static const VERSION_GETVERSION_POST = "/version/getVersion";

  ///查询视频专题 不分页
  ///参数：无
  ///返回：[VideoTopicModel]
  static const VIDEO_ALLTOPIC_POST = "/video/allTopic";

  ///查询视频专题 分页
  ///参数：AppTopicReq
  ///返回：[VideoTopicModel]
  static const VIDEO_ALLVIDEOTOPIC_POST = "/video/allVideoTopic";

  ///查询视频品种
  ///参数：AppCatagoryReq
  ///返回：int
  static const VIDEO_ALLVIDEOCATAGORY_POST = "/video/allVideoCatagory";

  ///查询所有视频标签
  ///参数：无
  ///返回：[VideoTagModel]
  static const VIDEO_ALLVIDEOTAG_POST = "/video/allVideoTag";

  ///热搜词
  ///参数：无
  ///返回：[VideoTagModel]
  static const HOT_SEARCH = "/video/getHotSearch";

  ///app端查询演员列表
  ///参数：AppActorsReq
  ///返回：[ActorsVideoResp]
  static const VIDEO_NEW_MORE_APPACTORS_POST = "/video/newAppMoreActors";

  ///app端查询演员列表
  ///参数：AppActorsReq
  ///返回：[ActorsVideoResp]
  static const VIDEO_NEW_APPACTORS_POST = "/video/newAppActors";

  ///app端查询演员列表
  ///参数：AppActorsReq
  ///返回：[ActorsVideoResp]
  static const VIDEO_APPACTORS_MORE_POST = "/video/appMoreActors";

  ///av搜索接口
  ///参数：SearchReq
  ///返回：SearchFinalResp
  static const VIDEO_APPSEARCHVIDEO_POST = "/video/avSearch";

  ///泡吧搜索接口
  ///keyword string //关键字
  ///skip    int    //跳过多少条
  ///limit   int    //查询多少条

  static const VIDEO_PAOBA_SEARCHVIDEO_POST = "/posts/search";

  ///泡吧博主搜索接口
  ///keyword string //关键字
  ///skip    int    //跳过多少条
  ///limit   int    //查询多少条
  static const VIDEO_PAOBA_USER_SEARCHVIDEO_POST = "/posts/search_user";

  ///app首页和视频模块查询视频列表
  ///参数：AppVideoReq
  ///返回：HomeVideoResp
  static const VIDEO_FINDVIDEO_POST = "/video/findVideo";

  ///app首页模块查询视频列表
  ///参数：AppVideoReq
  ///返回：HomeVideoResp
  static const VIDEO_AVPAGE_POST = "/video/avPage";

  ///app视频模块查询视频列表
  ///参数：AppVideoReq
  ///返回：HomeVideoResp
  static const VIDEO_SPPAGE_POST = "/video/spPage";

  /// 查询单个小视频
  /// 参数：{ "id": 0}
  /// 返回 { "canWatch": true}
  static const VIDEO_SINGLESP_POST = '/video/singleSp';

  /// 购买视频
  /// 参数：{ "id": 0}
  /// 返回 	{"msg": "操作成功"}
  static const VIP_BUYVIDEO_POST = '/vip/buyVideo';

  /// av 购买记录
  /// 参数：{ "lastCreatedAt": 0,"pageSize":20}
  /// 返回 	AvBuysRes
  static const VIDEO_AVBUYS_POST = '/video/avBuys';

  /// 小视频购买记录
  /// 参数：{ "lastCreatedAt": 0,"pageSize":20}
  /// 返回 SpBuysRes
  static const VIDEO_SPBUYS_POST = '/video/spBuys';

  ///根据女优查询视频
  ///参数：VideoByActorReq
  ///返回：VideoByActorResp
  static const VIDEO_FINDVIDEOBYACTOR_POST = "/video/findVideoByActor";

  ///查询单个视频
  ///参数：SingleVideoReq
  ///返回：SingleVideoResp
  static const VIDEO_GETSINGLEVIDEO_POST = "/video/singleAv";

  ///av播放接口
  static const VIDEO_PlAY_POST = "/v3/video/videoPlay";

  ///av推荐列表接口
  static const VIDEO_PLAY_RECOMMENT = '/v3/video/videoPlayRecomment';

  ///热搜榜
  ///参数：HotSearchboardReq
  ///返回：[VideoTagModel]
  static const VIDEO_HOTSEARCHBOARD_POST = "/video/hotSearchboard";

  ///排行榜查询(观影榜、新片榜、撸sir榜)
  ///参数：LeaderboardReq
  ///返回：LbFinalResp
  static const VIDEO_LEADERBOARD_POST = "/video/leaderboard";

  ///根据专题id查询视频列表
  ///参数：VideoByTopicIdReq
  ///返回：[VideoByTopicResp]
  static const VIDEO_VIDEOBYTOPIC_POST = "/video/videoByTopic";

  ///查���热搜词
  ///参数：GetHotSearchReq
  ///返回：[HotSearchModel]
  static const VIDEO_GETHOTSEARCH_POST = "/video/getHotSearch";

  ///创建一条VIP会员信息
  ///参数：VipCradReq
  ///返回：
  static const VIP_CREATE_POST = "/vip/create";

  ///获取vip卡片信息
  ///参数：无
  ///返回：GetAllVipCradRes
  static const VIP_GETALLLIST_GET = "/vip/getAllList";

  ///购买会员卡
  ///参数：VipCradReq
  ///返回：
  static const VIP_PAYVIPCRAD_POST = "/vip/payVipCrad";

  ///更新一��VIP会员信息
  ///参数：VipCradReq
  ///返回：
  static const VIP_UPDATE_POST = "/vip/update";

  ///删除某条银行卡信息
  ///参数：type 1 2
  ///返回：
  static const WALLET_DELETEBANKINFO_GET = "/wallet/deleteBankInfo";

  ///金额兑换泡花
  ///参数：ExchangeRes
  ///返回：
  static const WALLET_EXCHANGE_POST = "/wallet/exchange";

  ///获取全部交易记录
  ///参数：tranType:交易类型：兑换，购买，充值; pageIndex:分页索引; pageSize 分页size
  ///返回：TranResp
  static const WALLET_GETALLTRANSHISTORY_GET = "/wallet/getAllTransHistory";

  ///获取银行卡信息
  ///参数：无
  ///返回：Info
  static const WALLET_GETBANKINFO_GET = "/wallet/getBankInfo";

  ///获取钱包金额与泡花
  ///参数：无
  ///返回：WalletAmount
  static const WALLET_GETWALLET_GET = "/wallet/getWallet";

  ///更新银行卡信息
  ///参数：BankInfoReq
  ///返回：
  static const WALLET_UPDATEBANKINFO_POST = "/wallet/updateBankInfo";

  ///根据page查询提现记录 client请求获取提现记录数据,etc:skip=0&limit=3，跳过0页，取3条数据
  ///参数：Page
  ///返回：WithdrawRecordInfo
  static const WITHDRAW_PAGE_POST = "/withdraw/page";

  ///client提现请求
  ///参数：ClientReq
  ///返回：
  static const WITHDRAW_SUBMIT_POST = "/withdraw/submit";

  ///编辑个人信息
  /// nickName: 昵称 可以传nil  gender: 性别 1，女，2男
  ///返回：
  static const EDIT_USER_INFO_POST = "/user/info";

  ///编辑个人信息
  /// nickName: 昵称 可以传nil  gender: 性别 1，女，2男
  ///返回：
  static const EDIT_USER_SENSITIVE = "/sensitive/list";

  ///编辑头像
  ///参数：
  ///返回：
  static const EDIT_USER_LOGO_POST = "/user/logo";

  ///编辑封面
  ///参数：
  ///返回：
  static const EDIT_USER_COVER = "/userHome/updateBackImg";

  ///用户信息(作品和关注数)
  ///参数：
  ///返回：
  static const USER_DETAIL_INFO = "/userHome/info";

  ///编辑头像
  ///参数：
  ///返回：
  static const GROUP_QUERY_GET = "/group/query";

  ///获取个人资料
  ///参数：
  ///返回：
  static const USER_BASE_GET = "/user/base";

  ///推广
  ///参数：无
  ///返回： {url:	 分享url地址 inviteCode:	 邀请码}
  static const SHARE_CONTENT_GET = "/share/content";

  ///校验兑换码
  ///参数： exchangeCode
  ///返回：
  static const CHECK_EXCHANGE_CODE = "/exchangeCode/level";

  ///使用兑换码
  ///参数： exchangeCode
  ///返回：
  static const USE_EXCHANGE_CODE = "/exchangeCode/use";

  ///段视频列表接口
  ///参数： exchangeCode
  ///返回：
  static const SHORT_VIDEO_LIST = "/video/spPage";

  static const HOME_LIST = '/home/query';

  static const FILE_M3U8 = '/file/m3u8';

  ///全民代理
  static const INCOME = "/user/income";

  ///首页小编列表数据
  static const THEMATIC_LIST_GET = "/recommend/list";

  ///小编详情页AV列表
  static const THEMATIC_AV_VIDEO_LIST_POST = "/recommend/av";

  ///小编详情页短视频列表
  static const THEMATIC_SHORT_VIDEO_LIST_POST = "/recommend/sp";

  ///统计小编详情页用户视频浏览记录
  static const THEMATIC_STATISTICS_WATCH_TIME_POST = "/recommend/count";

  ///检测视频是否已下架
  ///参数： id
  ///返回：status
  static const CHECK_VIDEO_STATUS_GET = "/video/checkStatus";

  static const SHORT_VIDEO_COLLECTIONS = "/userVideo/spCollects";

  ////////////////////////////////  评论  ////////////////////////////////

  ///分片上传视频接口
  ///返回：string
  static const UPLOAD_VIDEO = "/upload/videoBody";

  ///上传图片接口
  ///返回：string
  static const UPLOAD_IMAGE = "/file/upload";

  ///视频发送完成接口
  ///返回：string
  static const VIDEO_OK = "/upload/videoOk";

  // 关注列表
  static const ATTENTION_LIST = "/userHome/attention";
  // 粉丝列表
  static const FAN_LIST = "/userHome/fans";
  // 关注或取消关注
  static const ATTENTION_OPERATE = "/userHome/operate";
  // 作品集个人信息
  static const USERHOME_INFO = "/userHome/info";
  // 作品列表
  static const USERHOME_VIDEO = "/userHome/video";

  ///视频发布接口
  ///返回: string
  static const VIDEO_ADD = "/posts/new";

  static const PORTFOLIO_VIDEO_Delete_POST = "/myWorks/deleteWoeks";

  static const PORTFOLIO_LIST_POST = "/myWorks/queryWoeks";

  /// 获取首页推荐内容
  ///参数：AppCatagoryReq
  ///返回：int
  static const RECOMMAND_POST = "/video/allVideoCatagory";

  ///{'Authorization': 'Bearer $token'};
  static const headers = {
    'ContentType': 'application/json;charset=utf-8',
  };

  /// 域名列表
  ///参数：type 类型 :1-Av域名、2-图片域名、3-apk域名、4-小视频域名
  ///返回：[{"id","domain":"line"}]
  static const CDN_LIST = "/cdn/list";

  /// ---------------- 贴住相关
  /// 关注 贴主
  /// /api/user/watch
  /// request: IdRequest
  /// response: {}
  static const USER_WATCH = "/user/watch";

  /// 取消关注 贴主
  /// /api/user/undo_watch
  /// request: IdRequest
  /// response: {}
  static const USER_UNDO_WATCH = "/user/undo_watch";

  /// 取消关注 贴主
  /// method: GET
  /// /api/user/rec_watch_list
  ///request: {}
  /// response: [UserBaseInfo]
  static const USER_REC_WATCH_LIST_GET = "/user/rec_watch_list";

  /// 我的基本数据
  /// method: post
  /// /api/user/target_base_info
  ///request: {}
  /// response: [UserBaseInfo]
  static const USER_TARGET_BASE_INFO_POST = "/user/target_base_info";

  /// 更新签名
  /// req personSignature 内容
  static const USERHOME_UPDATE_SING_POST = "/userHome/updatePersonSignature";

  /// ---------------- 帖子相关
  /// 新增
  /// action: /api/posts/new
  /// request: NewPostRequest
  /// response: NewPostResponse
  static const POSTS_NEW = "/posts/new";

  /// 关注 列表
  /// action: /api/posts/watch_list
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_WATCH_LIST = "/posts/watch_list";

  /// 精选 列表
  /// action: /api/posts/rec_list
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_REC_LIST = "/posts/rec_list";

  /// 最新 列表
  /// action: /api/posts/new_list
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_NEW_LIST = "/posts/new_list";

  /// 最热 列表
  /// action: /api/posts/hot_list
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_HOT_LIST = "/posts/hot_list";

  /// 帖子 点赞
  /// action: /api/posts/like
  /// request: IdRequest
  /// response: IdCountResponse
  static const POSTS_LIKE = "/posts/like";

  /// 帖子 取消点赞
  /// action: /api/posts/undo_like
  /// request: IdRequest
  /// response: IdCountResponse
  static const POSTS_UNDO_LIKE = "/posts/undo_like";

  /// 帖子 收藏
  /// action: /api/posts/fav
  /// request: IdRequest
  /// response: IdCountResponse
  static const POSTS_FAV = "/posts/fav";

  /// 取消收藏
  /// action: /api/posts/undo_fav
  /// request: IdRequest
  /// response: IdCountResponse
  static const POSTS_UNDO_FAV = "/posts/undo_fav";

  /// 删除帖子
  /// method: POST
  /// action: /api/posts/delete
  /// request: IdRequest
  /// response: {}
  static const POSTS_DELETE_POST = "/posts/delete";

  /// 购买帖子
  /// method: POST
  /// action: /api/posts/delete
  /// request: IdRequest
  /// response: {}
  static const POSTS_BUY_POST = "/posts/buy";

  /// 我的帖子 @
  /// method: POST
  /// action: /api/posts/my_list
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_TARGET_LIST_POST = "/posts/target_list";

  /// 我的 评论
  /// method: POST
  /// action: /api/posts/my_replys
  /// request: GetMyReplysRequest
  /// response: GetPostReplysResponse
  static const POSTS_TARGET_REPLYS_POST = "/posts/target_replys";

  /// 我的 收藏/购买
  /// method: POST
  /// action: /api/posts/my_fav_buy_posts
  /// request: GetPostsRequest
  /// response: GetPostsResponse
  static const POSTS_TARGET_FAV_BUY_POSTS_POST = "/posts/target_fav_buy_posts";

  /// 快速 获取评论
  /// method: POST
  /// action: /api/posts/quick_replys
  /// request: GetQuickReplysRequest
  /// response: GetQuickReplysResponse
  static const POSTS_QUICK_REPLYS_POST = "/posts/quick_replys";

  /// 查询单个帖子
  /// method: POST
  /// action: /api/posts/quick_replys
  /// request: id
  /// response: {"'post":PaoDataModel}
  static const POSTS_GET_POST = "/posts/get";

  //***********************活动 start************************
  static addActivity() {}
  //***********************活动 end**************************

  ///评论点赞
  static const COMMENT_LIKE = "/posts/reply_like";

  ///评论取消点赞
  static const COMMENT_UNLIKE = "/posts/reply_undo_like";

  ///获取一级和二级评论列表
  static const COMMENT_LIST = "/posts/reply_list";

  ///新增评论
  static const ADD_COMMENT = "/posts/reply_new";

  ///获取av模块分类

  static const GET_AV_CLASSIFY = "/get/classify";

  ///获取av模块分类页面的数据
  static const POST_AV_CLASSIFY_VIDEO = "/v3/video/categoryVideo";

  static const GET_AV_CLASSIFY_HOME = "/v3/video/categoryVideoHome";

  ///获取av模块精选页面轮播图数据
  static const POST_AV_SELECTED_CAROUSEL_VIDEO =
      "/post/selected/carousel/video";

  ///获取av模块精选页面视数据
  static const POST_AV_SELECTED_GROUP_VIDEO = "/v3/video/allTopicVideo";

  ///获取av模块金币专区页面数据
  static const POST_AV_GOLD_COIN_VIDEO = "/video/needPayVideos";

  ///获取av模块精选页面一组视频数据
  static const POST_AV_SELECTED_ONE_VIDEO = "/v3/video/topicVideo";

  ///获取av模块我的页面收藏数据
  static const POST_AV_MINE_COLLECTION_VIDEO = "/post/mine/collection/video";

  ///获取av模块我的页面购买数据
  static const POST_AV_MINE_PURCHASE_VIDEO = "/api/video/avBuysNew";

  ///获取av模块我的页面观影记录数据
  static const POST_AV_MINE_VIEW_RECORD_VIDEO = "/post/mine/view_record/video";
}
