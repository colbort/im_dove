import 'package:app/event/index.dart';
import 'package:app/lang/lang.dart';

///错误编码
class Code {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  //token过期
  static const AUTHORIZATION_OUTOFDATE = 6031;

  static const SUCCESS = 200;

  ///MARK:需要重新登录
  static const NEED_RELOGIN = 301;

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    eventBus.fire(HttpErrorEvent(code, message));
    return message;
  }

  /// 检查需要显示的错误
  static checkShowCode(code) {
    var c = code ~/ 1000;
    if (c == 8 || c == 6) return true;
    return false;
  }

  /// 获取错误提示
  static getMsg(int code) {
    if (checkShowCode(code)) return errCodes[code];
    return "";
  }

  /*
  * ParamLevel    = 1000  参数级
  * StoreLevel    = 3000  存储级
  * ServerLevel   = 4000  服务级
  * BusinessLevel = 6000  业务逻辑级
  * ESLevel       = 8000  es层 搜索引擎
  */
  static var errCodes = {
    1000: "无token",
    1001: "不可用的token，客户端需要重新登陆",
    1002: "方法为找到，指gin方法未找到",
    1003: "api未找到",
    1004: "限流",
    3000: "DBQuery",
    3001: "DBInsert",
    3002: "DBUpdate",
    3003: "DBDelete",
    3004: "RedisSet",
    3005: "RedisGet",
    3006: "RedisDel",
    3007: "ProxyPutObject",
    3008: "EtcdGet",
    3009: "EtcdPut",
    4000: "httpclient",
    4001: "指针类型",
    4002: "短信限制",
    4003: "短信发送失败",
    4004: "短信模版",
    4005: "短信模版解析",
    4006: "用户ID",
    4007: "打开文件",
    4008: "seaweedfs",
    4009: "context超时",
    4010: "json",
    4011: "fs filer",
    4012: "HttpGet",
    4013: "read data",
    4014: "io copy",
    4015: "pass",
    4016: "BSONMarshal",
    6000: "用户权限",
    6001: "未知错误",
    6002: "mongo数据库ID",
    6003: "用户名称",
    6004: "用户设备",
    6005: "手机号码",
    6006: "验证码",
    6007: "验证码ID",
    6008: "验证码错误",
    6009: "密码",
    6010: "用户" + Lang.zZf + "密码",
    6011: "数字类型",
    6012: "字符串类型",
    6013: "视频ID",
    6014: "进度",
    6015: "id数组",
    6016: "视频种类已存在",
    6017: "手机号码已绑定",
    6018: "返佣金比例",
    6019: "返佣",
    6020: "用户logo",
    6021: "UploadFile",
    6022: "EmptyFile",
    6023: "Operate user_video操作错误",
    6024: "BackgroundImg",
    6025: "UserDisable",
    6026: "NickName",
    6027: "Gender",
    6028: "LastLoginTime",
    6029: "InviteCode",
    6030: "Coat",
    6031: "ReLogin",
    6032: "PopType",
    6033: "Nodownloads",
    6034: "Nowatchs",
    6035: "AgentBinded",
    6036: "M3u8FileName",
    6037: "M3u8Read",
    6038: "VideoName",
    6039: "ExchangeCodeErr",
    6040: Lang.zCz + "通道已关闭",
    6041: "Withdraw",
    6042: "Task",
    8000: "ESBulk",
    8001: "ESMultiSearch"
  };
}
