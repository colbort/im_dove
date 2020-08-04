final cfg = _Cfg();

class _Cfg {
  // TODO 正式服务器，修改 _dev 为 false
  final _dev = true;

  bool get isDev => _dev;

  List<String> _hosts;

  _Cfg() {
    //  release模式

    const bool product = const bool.fromEnvironment("dart.vm.product");
    if (product) {
      _hosts = _urlsProd;
      return;
    }
    //  debug模式
    _hosts = _dev ? _urlDev : _urlsProd;
  }

  /// 放回可用的hosts信息。
  List<String> get hosts => _hosts;
  // 外部测试服务器线路
   final _urlDev = ["https://api.whuzxw.com"];

  // final _urlDev = ["http://192.168.3.109:8088"]; // 林动

  // final _urlDev = ["http://20.20.81.123:8099"];
  // final _urlDev = ["http://192.168.1.9:8088"];

  // final _urlDev = ["http://202.60.250.137:8088/"]; // 预发布

  // final _urlDev = ["http://20.20.81.123:8088"]; //  吕布

  // final _urlDev = ["http://20.20.81.187:8088"]; //  张鹏

//  final _urlDev = ["http://192.168.3.152:8888"]; //  发哥

  /// office urls 正式服务器线路
  final _urlsProd = [
    "https://pfapi1.com",
    "https://pfapi2.com",
    "https://pfapi3.com",
    "https://pfapi4.com",
    "https://pfapi5.com",
  ];
}
