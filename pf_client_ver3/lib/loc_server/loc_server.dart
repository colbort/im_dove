import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'vedio_event.dart';
import 'vedio_cache.dart';
import 'vedio_data.dart';
import 'download.dart';
import 'package:app/utils/logger.dart';
import 'req_parse.dart';

HttpServer server;
int serverPort = 8111;

resetServerState() async {
  if (server != null) {
    try {
      log.i("[LOCSERV] 关闭server");
      await server.close(force: true);
    } catch (e) {
      log.e("[LOCSERV] 关闭server失败，可能是因为服务被系统杀掉了");
    }
  }

  //启动server
  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, serverPort);
  } catch (e) {
    log.e("[LOCSERV] Couldn't bind to port $serverPort: $e");
    return;
  }

  String dir = await VedioCacheManager().getFilePath();

  server.listen((req) async {
    String sUri = req.uri.toString();
    // log.i("[LOCSERV] sUri:" + sUri);
    ReqType reqType = analysisReqType(sUri);
    // log.i("[LOCSERV] reqType:" + reqType.toString());

    String tmpName = sUri.substring(sUri.lastIndexOf('/') + 1);
    currentTsFrame = tmpName;
    //是否需要丢弃下载队列的任务,这里只会发生在切换视频源的时候，丢弃上一个视频堆积的请求
    if (isDropingDownload) {
      if (isNeedDrop(tmpName)) {
        log.i('catchingCurTsFrameName:' + catchingCurTsFrameName);
        log.i('[LOCSERV] drop req:' + sUri);
        req.response.statusCode = HttpStatus.notFound;
        await req.response.close();
        return;
      } else {
        isDropingDownload = false;
      }
    }

    if (hasMemoryCache(sUri)) {
      // log.i("[LOCSERV] 重复请求:" + sUri);
      req.response.headers.contentType =
          ContentType("application", "octet-stream", charset: "utf-8");
      req.response.add(getMemoryCache(sUri));
      // await req.response.flush();
      await req.response.close();
      return;
    }

    if (reqType == ReqType.m3u8) {
      await m3u8ReqParse(req, sUri, dir);
    } else {
      await keyAndTsReqParse(req, sUri, dir, reqType);
    }
  });
}

/// 启动后主线程调用初始化方法
Future runLocServ() async {
  String samplingFuc(String url) {
    if (url.indexOf('&name=') >= 0) {
      return url.substring(url.indexOf('&name=') + 1);
    } else {
      return url;
    }
  }

  //事件init
  eventInit();
  //数据初始化
  dataInit(samplingFuc);
  //cache初始化
  cacheInit();
  //download初始化
  downloadInit();

  //启动server
  resetServerState();
}
