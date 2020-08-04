import 'package:sprintf/sprintf.dart';

class Lang {
  // static final _instance = _Lang._();
  // factory _Lang() => _instance;
  // _Lang._();

  static String val(String key, {List<dynamic> args}) {
    return args != null ? sprintf(key, args) : key;
  }

  static String _mask(List<int> code) {
    var ret = '';
    code.forEach((val) => {ret += String.fromCharCode(val >> 2)});
    return ret;
  }

  /// 相冊或視頻選擇頁面
  static const UPLOAD_SELECT_VIDEO_TOOBIG = "視頻超過%dM，請重新選擇視頻。";
  static const UPLOAD_COMPRESS_PROGRESS = '視頻壓縮中%d%...';
  static const UPLOAD_UPLOAD_PROGRESS = '視頻上傳中%d%...';
  static const UPLOAD_PRE_UPLOAD_PROGRESS = '预览視頻上傳中%d%...';
  static const UPLOAD_COMPRESS_FAILED = '視頻壓縮失敗';
  static const UPLOAD_UPLOAD_COVER = '封面上傳中...';
  static const UPLOAD_UPLOAD_IMGS = '图片上傳中...';
  static const UPLOAD_VIDEO_PUBLISH = '視頻發布中...';
  static const UPLOAD_PRE_VIDEO_PUBLISH = '预览視頻發布中...';
  static const UPLOAD_VIDEO_PUBLISHSUC = '专题发布成功！';
  static const UPLOAD_VIDEO_PUBLISHFAIL = '視頻發布失敗，';
  static const UPLOAD_PRE_VIDEO_PUBLISHFAIL = '预览視頻發布失敗，';

  // 支付和兌換相關
  static var zBao = Lang._mask([103612, 80736, 94168]); //支付寶
  static var zCz = Lang._mask([83220, 82160]); //充值
  static var zWx = Lang._mask([97976, 81796]); //微信
  static var zTx = Lang._mask([102208, 118776]); //提現
  static var zYhk = Lang._mask([150016, 139568, 85380]); //銀行卡
  static var zQb = Lang._mask([150664, 85012]); //錢包
  static var zJe = Lang._mask([149316, 155956]); //金額
  static var zZf = Lang._mask([103612, 80736]);

  static const PHONE_PHONE = "手機號";
  static const PHONE_RELOG = "重新登錄";
  static const PHONE_AREA = "區號";
  static const PHONE_INPUTPHONE = "請輸入手機號";
  static const PHONE_INPUTCODE = "請輸入驗證碼";
  static const PHONE_REGET = "後重新獲取";
  static const PHONE_GETCODE = "獲取驗證碼";
  static const PHONE_BINDPHONE = "綁定手機號";
  static const PHONE_SWICHPHONE = "切換賬號";
  static const PHONE_CHGPHONE = "更換手機號";
  static const PHONE_RELOGTIPS = "您的賬號已再其他設備登錄，請重新登錄。";

  static const ENTER = "進入";
  static const QU_XIAO_QUAN_XUAN = "取消全選";
  static const QU_XIAO = "取消";
  static const QUAN_XUAN = "全選";
  static const SHANCHU = "刪除";
  static const SHOUCANG = "收藏";
  static const BIANJI = "編輯";
  static const QUXIAO = "取消";
  static const SHOUYE = "推薦";
  static const SHIPING = "原創";
  static const ZHUANTI = "專題";
  static const DENGRU = "登入";

  static const ZUNXIANGTEQUAN = "尊享特權";
  static const PROMOTION = "推廣一人獲得3天無限觀影";

  static const JINRIGUANGYINCISHU = "今日觀影次數";
  static const AVCISHU = "AV次數";
  static const DUANSHIPINCISHU = "短視頻次數";
  static const SHENGYUXIAZAICISHU = "剩餘下載次數";
  static const TUIGUANGRENSHU = "推廣人數";
  static const RENQINVYOU = "人氣女優";
  static const GENGDUO = "更多";
  static const QUEDING = "確定";
  static const SOUSUO = "搜索";
  static const SHEZHI = "設置";
  static const INPUTPWDWILL = "請輸入您要設置的密碼";
  static const REINPUTPWD = '請確認您要設置的密碼';
  static const ENSUREPASSOCDE = "確認密碼鎖";
  static const SETPASSOCDE = "設置密碼鎖";
  static const INPUTPWD = "請輸入您設置的密碼";
  static const SETSUCC = "設置成功！";
  static const DELSUCC = "刪除成功！";
  static const NOTTHESAME = "兩次輸入不一致，請重新輸入！";
  static const REMOVEPASSCODE = "刪除密碼鎖";
  static const TIPS = "提示";
  static const TIPS1 = "清除緩存後可能導致某些圖片加載失敗，退出App重進後即可";
  static const SAFECODEERR = "安全碼錯誤，請重新輸入！";

  static const ACCOUNTANDSAFE = "帳號與安全";
  static const SHOUJIHAO = "手機號";
  static const YINSI = "隱私";
  static const MIMASUO = "密碼鎖";
  static const QITA = "其他";
  static const OFFICALEMAIL = "官方郵箱";
  static const CLEANCACHE = "清除緩存";
  static const VERSIONNUM = "版本號";
  static const YUANFUHAO = "¥";
  static const BUYMEMBER = "購買會員";
  static const CASH = "餘額：";
  static const PAYWAY = "購買方式";
  static const GUANYINGJILU = "觀影記錄";
  static const CAINIXIHUAN = "猜你喜歡";
  static const QUEREN = "確認";
  static const JIAZAIZHONG = "加載中...";
  static const MEIYOUGENGDUOSHUJU = "沒有更多數據";
  static const SHUAXINWANCHENG = "刷新完成！";
  static const SONGKAIJIAZAIGENGDUO = "鬆開加載更多...";
  static const SHANGLAJIAZAIGENGDUO = "上拉加載更多";
  static const ZUOLAJIAZAIGENGDUO = "左拉加載更多";
  static const BUYINGPIAN = "部影片";
  static const GUANKANZHI = "觀看至";
  static const WODESHOUCANG = "我的收藏";
  static const WODEZUOPINJI = "作品集";
  static const WODEXIAZAI = "我的下載";
  static const GONGGAOXIAOXI = "公告消息";
  static const KAICHEQUN = "開車群";
  static var qianBao = Lang.zQb;
  static const DUIHUANMA = "兌換碼";
  static const QINGSHURUDUIHUANMA = "請輸入兌換碼";
  static const DUIHUANMABUHEFA = "兌換碼不合法!";
  static const DUIHUANMAJIAOYANSHIBAI = "兌換碼校驗失敗！";
  static const DUIHUANCHENGGONG = "兌換成功！";
  static const DUIHUANSHIBAI = "兌換失敗！";
  static const QUERENDUIHUAN = "確認兌換";
  static const KEFU = "在線客服";
  static const BIANJIZILIAO = "編輯資料";
  static const NICHEN = "暱稱";
  static const SEX = "性別";
  static const JIBENXINXI = "基本消息";
  static const GAITOUXIANG = "改頭像";
  static const XIUGAINICHEN = "修改" + Lang.NICHEN;
  static const XIUGAIGEXINGQIANMING = "修改" + '個性簽名';
  static const GERENJIESHAO = '填寫個人介紹更容易獲得關註，點擊此處添加簡介。';
  static const QINGSHURUNICHEN = "請輸入" + Lang.NICHEN;
  static const QINGSHURUGEXINGQIANMING = "請輸入個性簽名";

  static const TUIGUANG = "推廣";
  static const SISENTIVE_HINT = "暱稱包含敏感詞！";

  static const MIANFEIGUANKAN = "分享即可免費觀看";
  static const WODEYAOQINGMA = "我的邀請碼：";
  static const FUZHILIANJIEFENXIANG = "複製鏈接分享";
  static const BAOCUNTUPIANFENXIANG = "保存圖片分享";
  static const GUANYINGCISHU = "普通用戶每日觀影次數上限為9次（1次AV，8次短視頻）";
  static const TIPS2 = "推廣給好友成功下載並打開APP，您可獲得3天無限觀影次數特權。";
  static const TUIGUANG_RULE1 = "成功推廣1人,獲得3天無限觀看";
  static const TUIGUANG_DETAIL1 = "不知道如何邀請人？最強邀請攻略，3步助你輕鬆白嫖";
  static const TUIGUANG_DETAIL2 = '"複製鏈接"或"保存圖片"';
  static const TUIGUANG_DETAIL3 = "將保存的圖片或鏈接發送到以下渠道：";
  static var tuiGuangDetail4 =
      Lang.zWx + "群、QQ群、TG群、百度貼吧、微博、陌陌、知乎等,你平常使用的社交和社區軟件";
  static const TUIGUANG_DETAIL5 = "各種手遊的世界頻道等等";
  static const TUIGUANG_DETAIL6 = "被邀請用戶下載APP並成功註冊後即可生效";
  static const TUIGUANG_DETAIL7 = "*若邀請用戶綁定失敗可在【設置】中輸入你的邀請碼";
  static const FUZHILIANJIE = "複製鏈接";
  static const BAOCUNTUPIAN = "保存圖片";
  static const YAOQINGGONGLUE = "邀請攻略";
  static const WENXINTISHI = "溫馨提示";
  static const TIP_CONTENT1 = "已生成鏈接並保存到黏贴板";
  static const TIP_CONTENT2 = "將相冊中的圖片分享給好友即可";

  static const GONGGAO = "公告";
  static const UPDATA_TITLE = "新版本已閃亮登場～";
  static const UPDATA_SIZE = "大小：";
  static const UPDATA_VERSION = "版本：";
  static const UPDATA_TEXT = "內容";
  static const UPDATA_UPDATA = '更新';
  static const UPDATA_CHONGXIN = '重新下載';
  static const UPDATA_ANZHUANG = '安裝';
  static const UPDATA_DOWNLOADING = '正在下載...';
  static const WANGLUOCUOWU = '網絡錯誤,請重試!!!';
  static const XIALASHUAXIN = '下拉刷新...';
  static const ZONGYEJI = '總業績';
  static const ZONGSHOUYI = '總收益';
  static const DANGSHUJUTONGJI = '當日數據統計';
  static const DANGRISHOUYI = '當日收益 (元)';
  static const DANGRIYEJI = '當日業績 (元)';
  static const DANGRITUIGUANGRENSHU = '當日推廣人數';
  static const TUIGAUNGZONGSHUJU = '推廣總數據';
  static const ZONGTUIGUANGRENSHU = '總推廣人數';
  static const GUIZHE = '規則';
  static const QUANMINGDAILI = '全民代理';

  //  VIP
  static const VIP_MORE_DISCOUNT = '更多優惠  敬請期待';
  static const VIP_BUY_METHOD = '購買方式';
  static var vipWallet = Lang.zQb;
  static const VIP_CONFIRM = '確認';
  static const VIP_GIVE_UP = '放棄';
  static var vipInsuficientBalance = '餘額不足，請' + Lang.zCz;
  static var vipGoCharge = '去' + Lang.zCz;
  static const VIP_UNLIMITED_WATCH = '無限觀影次數';
  static const VIP_VALID_DAY = '有效日期%d天';
  static const VIP_BALANCE = '（餘額：%s元）';
  static const VIP_ZHUANXIANG = 'VIP專享視頻';
  static const VIP_JINGXUAN = '精選視頻，VIP才可觀看完整版哦～  ';
  static const VIP_TIPS1 = 'VIP專享視頻可免費觀看%s';
  static const GOUMAIBENPIAN = '購買本片';
  static const VIP_TIPS2 = "付費視頻可免費觀看%s";

  static const DIALOG_GOUMAI = '購買VIP';
  static const DIALOG_NO_TIMES = '今日免費播放次數已用完～';
  static const DIALOG_TUIGUANG_TIPS = '推廣和購買VIP就可以無限觀看哦😉';
  static const DIALOG_TUIGUANG = '去推廣';
  static const DIALOG_WANZHENGBAN = '完整版需付費';
  static const DIALOG_DAYE = '大爺～您還沒給錢呢';
  static const DIALOG_2YUAN = '2元';
  static const DIALOG_NYUAN = '%s元';
  static var gochongzhi = '去' + Lang.zCz;
  static const DIALOG_YUEBUY = '餘額購買';

  //  錢包
  static const WALLET_TRADE_RECORD = '交易記錄';
  static var walletCharge = Lang.zCz;
  static const WALLET_YUAN = '元';
  static const WALLET_BUY_VIP = '購買vip';
  static var walletWithdraw = Lang.zTx;
  static const WALLET_EXCHANGE = '兌換';
  static const WALLET_PROFIT = '收益';
  static const WALLET_BUY_VIDEO = '购买視频';
  static const WALLET_VIDEO_PROFIT = '視频收益';
  static const WALLET_IN = '中';
  static const WALLET_SUCCESS = '成功';
  static const WALLET_FAILED = '失敗';
  static var walletBao = Lang.zBao;
  static var walletOfficial = Lang.zWx;
  static var walletYin = Lang.zYhk;
  static const WALLET_LOOK_FORWARD = '敬請期待';
  static var walletChargeWay = Lang.zCz + '方式';

  //  充值
  static var chargeBao = Lang.zBao + Lang.zCz;
  static var chargeYin = Lang.zYhk + Lang.zCz;
  static var chargeOfficial = Lang.zWx + Lang.zCz;
  static var chargeAmount = Lang.zCz + Lang.zJe;
  static var chargeOtherMoney = '其他' + Lang.zJe;
  static const CHARGE_YUAN = '%s元';
  static var chargeInputMoney = '請輸入' + Lang.zCz + Lang.zJe;
  static const CHARGE_SINGLE_MONEY = '單筆限額¥%s~%s';
  static const CHARGE_POST_REQUEST = '提交申請';
  static const CHOOSE_A_CHARGET_ITEM_TIP = '請選擇一個充值項';
  static const CHOOSE_A_CHARGET_TYPE_TIP = '請選擇一個支付方式';
  static const PAYING_TIP = '已經在支付中,請勿重複提交請求';
  static var chargePostWating = Lang.zZf + '跳轉中……';

  static const DAILIGUIZHE = '代理規則';
  static const POTATO = "Potato群";
  static const TG = "TG群\n(大陸用戶使用Telegram需連接VPN)";
  static const LT = "雷霆加速器(VPN)";
  static const LIJIXIAZAI = "立即下載";
  static const LIJIJIARU = "立即加入";

  static const TEST = "單筆限額¥%s~%s";
  static const BUYSUCC = '購買成功';
  static const BUYFAIL = '購買失敗';
  static const WUXIAN = '無限';

  static const NVYOU = '女優';
  static const NVYOULIEBIAO = '女優列表';
  static const RENQIZUIGAO = '人氣最高';
  static const PIANLIANGZUIGAO = '片量最高';
  static const ZHAOBEI = '罩杯';
  static const QUANBU = '全部';
  static const NV = '女';
  static const NAN = '男';
  static const YIDONGHESUOFANG = '移動和縮放';
  static const WANCHENG = '完成';
  static const SHANGCHUANZHONG = '上傳中……';
  static const TUPIANXUANZEYOUWU = '圖片選擇有誤！';
  static const GUANGGAO = "廣告";
  static const HUODONG = "活動";

  static const GETCODE_SUC = "獲取驗證碼成功";
  static const GETCODE_FAIL = "獲取驗證碼失敗";
  static const OPER_SUC = "操作成功";
  static const OPER_FAIL = "操作失敗";
  static const OPER_BINDED_MOBILE = "此手機已綁定";
  static const INPUT_SEARCH = '請輸入搜索內容';
  static const SEARCH_HIS = '歷史搜索';
  static const SEARCH_HOT = '熱門搜索';
  static const VIP_MONTH = '月度會員卡';
  static const VIP_QUA = '季度會員卡';
  static const VIP_YEAR = '年度會員卡';

  /// 時間相關
  static const tJustnow = '剛剛';
  static const tMin = '%d分鐘前';
  static const tHour = '%d小時前';
  static const tDay = '%d天前';

  static const NO_NET = '您好像斷網了 請檢查網絡～';
  static const NO_DATA = '空蕩蕩的 啥也沒有呀～';
  static const LOAD_FAILED = '加載失敗了 刷新試試～';
  static const BACK_APP_TIP = '再次點擊,退出泡芙AV';
  static const DIANWOSHUAXIN = '點我刷新試試?';
  static const uWan = '萬';
  static const uYi = '億';

  static const IN_DEVELOPMENT = '開發中 敬請期待~';

  static const DOWNLOAD_ERR = "下載出錯了，請重試！";

  static const VIDEO_REMOVED = "該視頻已下架!";

  static const ASS_TEXT = '一鍵保存小助手，從此開車不迷路';
  static const TUIGUANGFULI = "推廣福利";
  static const TUIGUANGFULINEIRONG1 = "普通用戶每日可觀看AV1部+短視頻8部";
  static const TUIGUANGFULINEIRONG2 = "推廣分享便可獲得無限觀看次數";
  static const JIAMENG_TIP1_LEFT = "1.完全免費：";
  static const JIAMENG_TIP1_RIGHT = "培訓免費、使用免費、無任何費用";
  static const JIAMENG_TIP2_LEFT = "2.零投資：";
  static const JIAMENG_TIP2_RIGHT = "沒有任何門檻，專心推廣即可";
  static const JIAMENG_TIP3_LEFT = "3.一鍵搞定：";
  static const JIAMENG_TIP3_RIGHT = "只需一鍵分享轉發，操作簡單便捷";

  static const JIAMENG_TIP4_LEFT = "4.利潤高：";
  static const JIAMENG_TIP4_RIGHT = "平臺最高返利30%，多勞多得";
  static const JIAMENG_TIP5_LEFT = "5.財務透明：";
  static const JIAMENG_TIP5_RIGHT = "財務流水隨時查看核對，公開透明";

  static const JIAMENG_TIP6_LEFT = "6.提現方便：";
  static const JIAMENG_TIP6_RIGHT = "操作簡單，到賬迅速";
  static const FENGXIANG = "分享";
  static const ZHUAN = "賺";
  static const LINGHUAQIAN = "零花錢還可免費觀看哦～";
  static const JIAMENGDAILI = "加盟代理福利";
  static const WODEDAILI = "我的代理";
  static const TUIGUANGDAILi = "推廣代理";
  static const SHUJUCUOWU = "數據錯誤，請重試！";
  static const WATCHTIMES = "觀看%s次";

  //上傳視頻
  //上傳規則
  static const SHANGCHUANGUIZE =
      "1、上傳的視頻將由平臺進行審核，審核時間為24小時內，請註意查收反饋。 \n2、上傳的作品可在“我的-作品集”中查看審核進度和管理。 \n3、在視頻中任意位置，發現添加聯繫��式或插入廣告���將永久禁止���傳。 \n4、收費�����頻��須為原�������������視頻，非原創視頻��置成��費將會被管理員強制設置為免費。";

  //上傳說明
  static const SHANGCHUANSHUOMING =
      "1、原創作品更容易通過審核，通過網络下載其他視頻容易重複且不容易通過審核�� \n2、視頻中帶有“泡芙視頻”或“pf.live”字樣更容易通過審核。 \n3、禁止上傳未成年、獸交、真實強姦、偷拍等侵害他人隱私的視頻。 \n4、上傳AV視頻片段將不會通過審核。 \n5、視頻中當事人均需18歲以上，且當事人均同意視頻被上傳分享。 \n6、畫面模糊，視頻中帶有其他網站字樣、網址將不會通過審核。 \n7、為加強用戶隱私性，允許對視頻中人物面部等重要部分遮擋或打馬賽克。";

  //設置價格
  static const SHEZHIJIAGE =
      "收費視頻必須為原創視頻，否則全部視為免費視頻；\n收費視頻必須攜帶“泡芙視頻”或“pf.live”字樣；\n為了維護觀看體驗，推薦單個視頻價格為1元人民幣。";
  static const BUY = "付費";
  static const DUAN_VIDEO = "短視频";
  static const JINGPIN_VIDEO = "精品AV";
  static const BUY_VIDEO = "已購視頻";
  static const TUIJIANLIYOU = "推薦理由";
  static const BIANJITUIJIAN = "编辑推荐";
  static const ZHUYAN = "主演：";
  static const TUIJIANZXHISHU = "推荐指数";
  static const TUIJIANZXHISHU_TIP = "推荐指数:";
  static const SHENHE_FAIL = "審核失敗";
  static const SHENHE_ZHONG = "審核中~";

  static const COMMENT_PLACEHOLDER2 = "你不在這裏插入點什麽嗎...";
  static const PORTFOLIO_REASON_LABEL = "駁回原因";
  static const JINRITUIJIAN = "今日推薦";

  static const TUIGUANGMIAOSHU = "參與推廣代理，看視頻也賺錢";
  static const CHAKANXIANGQING = "查看詳情";

  /// av
  static const AV_CLASSIFY = "分類";
  static const AV_SELECTED = "精選";
  static const AV_GOLD_COIN_AREA = "金幣專區";
  static const AV_ACTRESS = "女優";
  static const AV_WODE = "我的";
  static const AV_ANOTHER_BATCH = "換一換";
  static const AV_COLLECTION = "收藏";
  static const AV_PURCHASE = "購買";
  static const AV_VIEWING_RECORD = "觀影記錄";
  static const AV_ALREADY_PURCHASE = "已購買";
  static const AV_WATCH_PERCENT = "觀看至";
  static const AV_VIP_FREE = "會員免費";

  /// 我的
  static const WODE = "我的";
  static const VIP = "会员中心";
  static const QUTUIGUANG = "去推廣";
  static const TUIGUANG_TIP = "推廣好友，無限觀看";
  // 首页
  static const RECOMMAND_GUANFANG = "官方推薦";
  static const RECOMMAND_PAOYOU = "泡友推薦";
  static const RECOMMAND_BANGDAN = "榜單";

  static const PAOYOUFULI = "泡友福利群";
  static const YIJIANJIAQUN = "一鍵加群,開車撩妹兩不誤";
  static const FANGQIANGBIBEI = "翻牆必備";
  static const WUXUDENGDAI = "翻牆看片，無需等待";

  /// 泡吧
  static const GUANZHU = "關注";
  static const ZUIXIN = "最新";
  static const ZUIRE = "最熱";
  static const JINGXUAN = "精選";

  static const VIP_FREE = "會員免費";
  static const YIGUANZHU = "已關注";

  static const COMMENT_NO_DATA = "暫無評論數據";
  static const COMMENT_NOTIFY = "快去發表評論吧！";
  static const COMMENT_INPUT_TIP = "留下妳精彩的評論吧";
  static const AUTHOR = "作者";
  static const COMMENT_SHOW_MORE_REPLY = "展開更多回復";
  static const String SET_FENGMIAN = "设置封面";
  static const PAOBA = "泡吧";
  static const FENSI = "粉絲";
  static const WODETIEZI = "我的帖子";
  static const TADETIEZI = "他的帖子";
  static const COMMENT_HUIFU = "评论/回复";
  static const SHOUCANG_YIGOU = "收藏/已购";
  static const COMMENT_TIP1 = "評論了您的作品";
  static const COMMENT_TIP2 = "回復了您的評論";
  static const COMMENT_FAILD = "评论发布失败";
  static const HOT_POST_TUIJIAN = "热门博主推荐";
  static const DELETE_POST = "刪除帖子";
  static const XX_HOMEPAGE = "%s 的主页";
  static const PINGLUN = "评论";
  static const POST_DETAIL = "帖子详情";
  static const SHURU_JIANJIE = "輸入簡介";
  static const SIGN_FAILD = "簽名設置失敗";
  static const VIDEO_TIP_N = "精選視頻,付費%s元才可觀看哦～";
  static const LIJI_BUY = "立即購買";
  static const QU_CHONGZHI = "去充值";

  /// 公共的
  static const QUXIAOGUANZHUI = "取消關注";
  static const QUXIAOGUANZHU = "取消關注成功";
  static const GUANZHUSUCC = "關注成功";
  static const QUXIAOSHOUCANG = "取消收藏成功";
  static const SHOUCANGSUCC = "收藏成功";
  static const QUXIAODIANZAN = "取消點贊成功";
  static const DIANZANSUCC = "點贊成功";
  static const BOUGHT = "已購買";

  ///搜索
  static const HUATI = "話題";
  static const PAOYOU = "泡友";
}
