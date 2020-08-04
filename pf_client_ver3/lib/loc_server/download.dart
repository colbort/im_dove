import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'vedio_data.dart';
import 'package:app/utils/logger.dart';

typedef MyProgressCallback = void Function(
    int count, int total, Uint8List data);

final baseOptions = BaseOptions(
  method: "GET",
  //连接服务器超时时间，单位是毫秒.
  connectTimeout: 10000,
  //响应流上前后两次接受到数据的间隔，单位为毫秒。
  receiveTimeout: 10000,
  //Http请求头.
  headers: {"user-agent": "dio", "api": "1.0.0"},
  //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
  contentType: ContentType.binary.toString(),
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.stream,
);

final options = Options(
  method: "GET",
  //连接服务器超时时间，单位是毫秒.
  sendTimeout: 10000,
  //响应流上前后两次接受到数据的间隔，单位为毫秒。
  receiveTimeout: 10000,
  //Http请求头.
  headers: {"user-agent": "dio", "api": "1.0.0"},
  //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
  contentType: ContentType.binary.toString(),
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.stream,
);

Dio _dio;
List<CancelToken> cancleTokenList;

downloadInit() {
  _dio = Dio(baseOptions);
  // dio.onHttpClientCreate = _onHttpClientCreate;
  cancleTokenList = List<CancelToken>();
}

cancelDownload(CancelToken _cancleToken) {
  _cancleToken.cancel("cancelled");
}

cancelCurDownloadAndDrop() {
  isDropingDownload = true;
  for (var token in cancleTokenList) {
    if (token != null) cancelDownload(token);
  }

  cancleTokenList.clear();
}

int getNowSpeed() {
  return speed;
}

int lastGetStreamTime = 0;
int lastRecSize = 0;
int speed = 0;
//FUNC:下载
getFile(urlPath, _onReceiveProgress, _onDone, _onError, _cancelToken) async {
  lastGetStreamTime = DateTime.now().millisecondsSinceEpoch;
  lastRecSize = 0;
  Response response;
  try {
    response = await _dio.get(
      urlPath,
      cancelToken: _cancelToken,
      options: options,
    );
    log.i("网络超时设置:" + response.request.receiveTimeout.toString());

    var stream = response.data.stream;
    stream = stream.timeout(
      Duration(milliseconds: response.request.receiveTimeout),
      onTimeout: (EventSink sink) {
        sink.addError(DioError(
            error: "Receiving data timeout[${options.receiveTimeout}ms]",
            type: DioErrorType.RECEIVE_TIMEOUT));
        sink.close();
      },
    );
    var recData = List<int>();
    var received = 0;
    var total = int.parse(response.headers.value("content-length") ?? "-1");
    stream.listen(
      (data) {
        recData.addAll(data);
        received += data.length;
        var nowTime = DateTime.now().millisecondsSinceEpoch;
        var nowReceived = received - lastRecSize;
        var usedTime = nowTime - lastGetStreamTime;
        if (usedTime >= 300 && usedTime > 0) {
          speed = (nowReceived * 1000) ~/ usedTime;
          speed = speed >= 0 ? speed : 0;
          log.i("speed:" + speed.toString());
          lastGetStreamTime = nowTime;
          lastRecSize = received;
        }
        _onReceiveProgress(received, total, data);
      },
      onDone: () {
        log.i('downloadFile success---------${response.data}');
        _onDone(recData);
      },
      onError: (e) {
        log.w("stream err: $e");
        if (e is DioError && e.type != DioErrorType.CANCEL) speed = 0;
        _onError(e);
      },
      cancelOnError: true,
    );
  } on DioError catch (e) {
    log.w('downloadFile error---------$e');
    if (e.type != DioErrorType.CANCEL) speed = 0;
    if (_onError != null) {
      _onError(e);
    }
  }

  return (response != null) ? response.data : null;
}
