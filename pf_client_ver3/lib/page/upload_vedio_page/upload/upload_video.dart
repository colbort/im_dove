import 'dart:async';

import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/utils/hosts.dart';
import 'package:app/utils/utils.dart';
import 'package:app/utils/video_cmd_helper.dart';
import 'package:app/widget/common/toast/src/core/toast.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:app/utils/logger.dart';
import 'package:app/net/routers.dart';
import 'package:flutter/material.dart';
import 'package:md5_plugin/md5_plugin.dart';
import 'dart:convert' show base64;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

final Dio _dio = Dio();

var options = Options(
  method: "POST",
  //连接服务器超时时间，单位是毫秒.
  sendTimeout: 30000,
  //响应流上前后两次接受到数据的间隔，单位为毫秒。
  receiveTimeout: 30000,
  //Http请求头.
  headers: {"user-agent": "dio", "api": "1.0.0"},
  //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
  contentType: ContentType.json.toString(),
  //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
  responseType: ResponseType.json,
);

//当前最新正在上传的片段，从1开始
int uploadPatchIdx = 0;
//视频最大片段数
int maxPatchIdx = 0;
//单片视频片段容量
int patchSize = 0;
//服务器返回的视频id
String videoId = "";
String videoUri = "";
//同时最多进行几个上传任务
final int maxUploadTask = 4;
Function progressCallback;
List<int> uploadFinishedIdxArr = List<int>();
Future uploadVideo(String localPath, Function _progressCallback) async {
  progressCallback = _progressCallback;
  uploadFinishedIdxArr.clear();
  options.headers["Authorization"] = await getToken();
  options.headers["User-Agent"] = net.userAgent();
  File uploadFile = File(localPath);
  int fileSize = await uploadFile.length();
  Map<String, dynamic> patchMap = getPatchResult(fileSize);
  patchSize = patchMap['patchSize'];
  maxPatchIdx = patchMap['patchCount'];
  log.i(
      "分段大小:" + patchSize.toString() + " 视频被分成多少个片段:" + maxPatchIdx.toString());
  log.i("上传视频地址:" + hosts.host);
  String taskId = getTaskID(localPath);
  List<Future<Response>> responseFutureList = List();

  int loopMaxIdx = maxUploadTask < maxPatchIdx ? maxUploadTask : maxPatchIdx;
  for (int i = 0; i < loopMaxIdx; i++) {
    responseFutureList.add(_uploadPatch(i + 1, taskId, 2, uploadFile));
  }
  await Future.wait(responseFutureList);
  return videoUri;
}

Future<Response> _uploadPatch(
    int idx, String taskId, int type, File uploadFile) async {
  log.i("视频上传 idx:" + idx.toString());
  log.i("taskId:" + taskId.toString());
  uploadPatchIdx = uploadPatchIdx < idx ? idx : uploadPatchIdx;
  int shouldReadLen = idx < maxPatchIdx
      ? patchSize
      : min((await uploadFile.length()) % patchSize, patchSize);
  Uint8List list =
      (await getFileBlock((idx - 1) * patchSize, shouldReadLen, uploadFile));

  var postData = {
    'fileData': base64.encode(list),
    'pos': idx,
    'taskId': taskId,
    'type': type.toString(),
  };

  // var postData = FormData.fromMap({
  //   'fileData': base64.encode(list),
  //   'pos': idx,
  //   'taskId': taskId,
  //   'type': type.toString(),
  // });

  try {
    Response resp = await _dio.post(hosts.host + Routers.UPLOAD_VIDEO,
        data: postData, options: options);
    if (resp.data is DioError) {
      log.i("upload err1: $e");
      await Future.delayed(Duration(seconds: 1));
      return _uploadPatch(idx, taskId, type, uploadFile);
    }

    if (resp.statusCode == 200 && resp.data['code'] == 200) {
      if (!uploadFinishedIdxArr.contains(idx)) uploadFinishedIdxArr.add(idx);
      double progess = uploadFinishedIdxArr.length * 1.0 / maxPatchIdx;
      if (progressCallback != null) {
        progressCallback(progess);
      }
      log.i('resp.data:' + resp.data.toString());
      videoId = resp.data['data']['id'].toString();
      videoUri = resp.data['data']['videoUri'].toString();
      log.i("视频上传成功 idx:" + idx.toString() + ' videoId:' + videoId);
      if (uploadPatchIdx < maxPatchIdx) {
        uploadPatchIdx++;
        return _uploadPatch(uploadPatchIdx, taskId, type, uploadFile);
      } else {
        return resp;
      }
    } else {
      log.i("upload failed msg:" + resp.data.toString());
      await Future.delayed(Duration(seconds: 1));
      return _uploadPatch(idx, taskId, type, uploadFile);
    }
  } on DioError catch (e) {
    log.i("upload err2: $e");
    await Future.delayed(Duration(seconds: 1));
    return _uploadPatch(idx, taskId, type, uploadFile);
  }
}

Future<File> writeToFile(ByteData data, String fileName) async {
  final buffer = data.buffer;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  var filePath = tempPath + '/' + fileName;
  return new File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

///图片上传
Future uploadImage(
  String localPath,
) async {
  String coverImg = '';
  try {
    // Uint8List list = await File(localPath)?.readAsBytes();
    // var postData = FormData.fromMap({
    //   'fileData': base64.encode(list),
    //   'ext': 'jpeg',
    //   'id': params['videoId'],
    // });

    var name =
        localPath.substring(localPath.lastIndexOf("/") + 1, localPath.length);
    var args = FormData.fromMap(
        {'file': await MultipartFile.fromFile(localPath, filename: name)});

    RespData resp = await net.request(Routers.UPLOAD_IMAGE, args: args);

    if (resp.code == 200) {
      log.i('resp.data:' + resp.data.toString());
      coverImg = resp.data;
    } else {
      if (resp.code == 413) {
        showToast('图片太大,请重新上传！');
      }
      await Future.delayed(Duration(seconds: 1));
    }
  } catch (e) {
    print(e.toString());
  }

  return coverImg;
}

Future<bool> videoOk(BuildContext ctx, Map<String, dynamic> params) async {
  RespData resp = await net.request(Routers.VIDEO_OK, args: {
    'id': videoId,
    'tags': params['tags'],
    'title': params['text'],
  });

  log.i('videoOk resp:' + resp.toString());
  //协议错误，直接提示
  if (resp.code == 200 && resp.data['code'] == 200) {
    return true;
  } else {
    if (resp.code == 0) {
      await Future.delayed(Duration(seconds: 1));
      return videoOk(ctx, params);
    } else {
      params['errmsg'] = resp.data['msg'];
      return false;
    }
  }
}

///视频发布
Future<bool> confirmPublish(
    BuildContext ctx, Map<String, dynamic> params) async {
  RespData resp = await net.request(Routers.VIDEO_ADD, args: params);

  if (resp.code == 200) {
    log.i("视频发布返回: " + resp.data.toString());
    return true;
  } else {
    if (resp.code == 0) {
      await Future.delayed(Duration(seconds: 1));
      return confirmPublish(ctx, params);
    } else {
      log.i("视频发布错误返回: " + resp.toString());
      if (resp.data != null) {
        params['errmsg'] = resp.data['msg'];
      } else {
        params['errmsg'] = Lang.WANGLUOCUOWU;
      }

      return false;
    }
  }
}

Future<String> getFileMD5(String localPath) async {
  if (localPath == null) {
    return '';
  }
  var ret = '';
  var file = File(localPath);
  if (await file.exists()) {
    try {
      ret = await Md5Plugin.getMD5WithPath(localPath);
    } catch (exception) {
      log.e('Unable to evaluate the MD5 sum :$exception');
      return '';
    }
  } else {
    return '';
  }
  return ret;
}

String getTaskID(String localPath) {
  if (localPath == null) {
    return "";
  }
  Uint8List fileBytes = File(localPath).readAsBytesSync();
  Uint8List needBytes =
      fileBytes.sublist(0, min(fileBytes.lengthInBytes, 4096));
  var digest = md5.convert(needBytes);
  return digest.toString().toLowerCase();
}

Future<int> getFileSize(String localPath) {
  if (localPath == null) {
    return Future.value(0);
  }
  File file = File(localPath);
  if (file.existsSync()) {
    return file.length();
  }
  return Future.value(0);
}

/// offset    起始偏移位��
/// file      文件
/// blockSize 分块大小
Future<Uint8List> getFileBlock(int offset, int blockSize, File file) async {
  Uint8List result = Uint8List(blockSize);
  RandomAccessFile accessFile;
  try {
    accessFile = await file.open();
    accessFile = await accessFile.setPosition(offset);
    log.i('offset:$offset blocksize:$blockSize');
    result = await accessFile.read(blockSize);
    if (result == null) {
      return Future.value(Uint8List.fromList([]));
    } else {
      return result;
    }
  } on Exception catch (e) {
    log.e('getFileBlock err: $e');
    return Future.value(Uint8List.fromList([]));
  } finally {
    if (accessFile != null) {
      accessFile.close();
    }
  }
}

/// 获取视频信息
Future<Map<String, dynamic>> getMediaInfo(String localPath) async {
  if (localPath == null || localPath.isEmpty) return Future.value(null);
  Map<String, dynamic> infoMap = {};
  var videoInfo = await VideoCmdHelper().getVideoInfos(localPath);
  int size = videoInfo["size"] ?? 0;
  if (size == 0) {
    return Future.value(null);
  }
  int duration = videoInfo["playTime"] ?? 0;
  int width = videoInfo["width"] ?? 0;
  int height = videoInfo["height"] ?? 0;
  //bytes
  infoMap['size'] = size;
  infoMap['width'] = width;
  infoMap['height'] = height;
  //width/height
  infoMap['ratio'] = width * 1.0 / height;
  //seconds
  infoMap['playTime'] = duration ~/ 1000;
  return infoMap;
}

///计算分片大小和数量
Map<String, dynamic> getPatchResult(int fileSize) {
  Map<String, dynamic> resultMap = {};
  int patchSize = 2 * 1024 * 1024;
  int patchCount = fileSize ~/ patchSize + (fileSize % patchSize > 0 ? 1 : 0);
  resultMap['patchSize'] = patchSize;
  resultMap['patchCount'] = patchCount;
  return resultMap;
}
