import 'dart:io';
import 'package:app/net2/net_manager.dart';
import 'package:path/path.dart';
import 'package:app/net/net.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'logger.dart';
import 'native.dart';

final version = _Version();

class _Version {
  var needUpdate = false;
  var isForceUpdate = false;
  var downloadLink = '';
  var info = '';
  var size = '';
  String versionLocal;
  String versionRemote;

  var inited = false;
  _Updater _updater = _Updater();

  Future<void> init() async {
    versionLocal = await n.getVersionName();
  }

  Future<bool> initUpdater() async {
    await _updater.init();
    bool rlt = await requestVer();
    inited = true;
    return rlt;
  }

  /// [return] [VersionState]
  Future<bool> requestVer() async {
    Map<String, dynamic> paramters = {'terminal': Platform.operatingSystem};
    if (Platform.operatingSystem == 'ios') {
      //TODO 不同的包传的packageType值不一样 要在这里进行修改一波
      //1 企业 2 appstore 3 tf 4 超级签
      //iOS
      var installTF = await n.installTestFlight();
      paramters['packageType'] = 1;
      paramters['installedTf'] = installTF;
    } else {
      // Android
      paramters['packageType'] = 1;
    }
    var resp =
        await net.request(Routers.VERSION_GETVERSION_POST, args: paramters);
    if (resp.code != 200 || resp.data == null) return false;

    var data = resp.data;
    versionRemote = data['versionNum'];

    if (versionRemote == null || versionRemote == "") {
      return false;
    }

    var verLocalArr = versionLocal.toString().split('.').map((v) {
      return int.parse(v);
    }).toList();
    var verRemoteArr = versionRemote.toString().split('.').map((v) {
      return int.parse(v);
    }).toList();

    needUpdate = false;
    for (int i = 0; i < verLocalArr.length; i++) {
      if (verRemoteArr[i] > verLocalArr[i]) {
        needUpdate = true;
        break;
      } else if (verRemoteArr[i] < verLocalArr[i]) {
        needUpdate = false;
        break;
      }
    }

    // needUpdate = versionLocal != versionRemote && versionRemote != '';

    isForceUpdate = data['isForceUpdate'];
    downloadLink = data['link'].toString().trim();
    info = data['info'];
    size = data['size'];
    log.i('[VER] lcoal ver: <$versionLocal>;\n' +
        '[VER] remote ver: <$versionRemote>;\n' +
        '[VER] needUpdate: $needUpdate;\n' +
        '[VER] forceUpdate: $isForceUpdate;\n' +
        '[VER] link: $downloadLink');

    return true;
  }

  /// 使用新的retrofit版本 测试
  Future<bool> requestVer2() async {
    Map<String, dynamic> paramters = {'terminal': Platform.operatingSystem};
    if (Platform.operatingSystem == 'ios') {
      //TODO 不同的包传的packageType值不一样 要在这里进行修改一波
      //1 企业 2 appstore 3 tf 4 超级签
      //iOS
      var installTF = await n.installTestFlight();
      paramters['packageType'] = 1;
      paramters['installedTf'] = installTF;
    } else {
      // Android
      paramters['packageType'] = 1;
    }

    var data = await netManager.client.getVersion(paramters);
    if (data == null) return false;

    versionRemote = data.versionNum;

    if (versionRemote == null || versionRemote == "") {
      return false;
    }

    var verLocalArr = versionLocal.toString().split('.').map((v) {
      return int.parse(v);
    }).toList();
    var verRemoteArr = versionRemote.toString().split('.').map((v) {
      return int.parse(v);
    }).toList();

    needUpdate = false;
    for (int i = 0; i < verLocalArr.length; i++) {
      if (verRemoteArr[i] > verLocalArr[i]) {
        needUpdate = true;
        break;
      } else if (verRemoteArr[i] < verLocalArr[i]) {
        needUpdate = false;
        break;
      }
    }

    isForceUpdate = data.isForceUpdate;
    downloadLink = data.link.trim();
    info = data.info;
    size = data.size;

    log.i('[VER] lcoal ver: <$versionLocal>;\n' +
        '[VER] remote ver: <$versionRemote>;\n' +
        '[VER] needUpdate: $needUpdate;\n' +
        '[VER] forceUpdate: $isForceUpdate;\n' +
        '[VER] link: $downloadLink');

    return true;
  }

  get update {
    if (inited) {
      return _updater.update;
    } else {
      log.i('Version not ready!');
      return () {};
    }
  }

  Future<bool> installApk() async => _updater.install();

  void cancelUpdate() => _updater.cancel();

  get isDownloading => _updater.isDownloading;
  get isDownloaded => _updater.isDownloaded;
}

enum _UpdaterState { INIT, ERROR, DONWLAODING, DONWLAODED }

/// only andoird
class _Updater {
  Dio _dio;
  String _apkPath;
  CancelToken _cancelToken;
  // bool isDownloaded = false;
  _UpdaterState state;

  _Updater() {
    if (!Platform.isAndroid) return;
    _cancelToken = CancelToken();

    _dio = Dio(BaseOptions(
      method: "GET",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 5000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5 * 60 * 1000,
      //Http请求头.
      headers: {"user-agent": "dio", "api": "1.0.0"},
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.binary.toString(),
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.stream,
    ));
  }

  Future<void> init() async {
    if (!Platform.isAndroid) return;
    var dir = (await getExternalStorageDirectory())?.path;
    _apkPath = join(dir, 'tmp.apk');
    state = _UpdaterState.INIT;
  }

  /// 取消当前下载
  void cancel() {
    if (state == _UpdaterState.DONWLAODING) {
      _cancelToken?.cancel();
    }
  }

  get isDownloading => state == _UpdaterState.DONWLAODING;

  get isDownloaded => state == _UpdaterState.DONWLAODED;

  /// only andoird
  /// [return] [String]
  Future<bool> update(String url,
      {Function(int received, int total) onProgress}) async {
    try {
      // 开始下载
      state = _UpdaterState.DONWLAODING;
      await _dio.download(
        url,
        _apkPath,
        cancelToken: _cancelToken,
        onReceiveProgress: onProgress,
      );
      // 下载完成；
      state = _UpdaterState.DONWLAODED;
      // isDownloaded = true;
      return true;
    } on DioError catch (e) {
      log.i("download err:" + e.toString());
      // 下载出错；
      state = _UpdaterState.ERROR;
      return false;
    }
  }

  Future<bool> install() async {
    if (!isDownloaded) {
      log.w('apk not download yet.');
      return false;
    }
    await n.installApkFile(_apkPath);
    return true;
  }
}
