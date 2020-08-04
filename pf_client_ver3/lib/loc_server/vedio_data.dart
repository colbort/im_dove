import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'download.dart';
import 'package:app/utils/logger.dart';

import 'loc_server.dart';

/// 将源url转为用来md5采样的URL，去掉源url中经常变化的元素，比如域名，token这些
typedef Md5Sampling = String Function(String originalUrl);
Md5Sampling md5sampling;

//完整的远端m3u8请求url，key为通过u3u8采用生成的md5
Map<String, String> completeM3u8Url = Map<String, String>();
//前面的短域名，用来请求key文件使用，key为通过u3u8采用生成的md5
Map<String, String> m3u8DomainUrl = Map<String, String>();
//m3u8的名字， key为通过u3u8采用生成的md5
Map<String, String> m3u8Name = Map<String, String>();

String currentTsFrame;

List<String> cacheSucReqUrl;
List<List<int>> cacheReqData;
int cacheIdx;
final cacheAmount = 5;

// m348结构解析列表 key:url md5
var m3u8InfoMap = Map<String, M3u8Info>();

String localHost;

//是否正在丢弃过时的下载请求
bool isDropingDownload = false;
//当前跳到了哪一块ts片段
String catchingCurTsFrameName;

//MARK:下载配置
class M3u8Info {
  List<int> timeList;
  List<String> tsList;
  //key地址
  String keyUrl;
  //给与m3u8域名地址不一样的ts片段组装使用
  String tsDoaminUr;
  //m3u8解析
  Uint8List m3u8;
}

dataInit(_md5sampling) {
  cacheSucReqUrl = List<String>();
  cacheReqData = List<List<int>>();
  cacheIdx = 0;
  localHost = InternetAddress.loopbackIPv4.address.toString() + ':$serverPort/';
  if (!localHost.contains('http://')) {
    localHost = 'http://' + localHost;
  }
  isDropingDownload = false;
  log.i("localHost:" + localHost);
  md5sampling = _md5sampling;
}

memoryCache(String sUri, List<int> data) {
  if (cacheSucReqUrl.length < cacheAmount) {
    cacheSucReqUrl.add(sUri);
    cacheReqData.add(data);
  } else {
    cacheIdx = cacheIdx >= cacheAmount ? 0 : cacheIdx;
    cacheSucReqUrl[cacheIdx] = sUri;
    cacheReqData[cacheIdx] = data;
    cacheIdx++;
  }
}

hasMemoryCache(String sUri) {
  return cacheSucReqUrl.contains(sUri);
}

getMemoryCache(String sUri) {
  var idx = cacheSucReqUrl.indexOf(sUri);
  if (idx >= 0) {
    return cacheReqData[idx];
  } else {
    return null;
  }
}

/// m3u8远程地址转本地地址  远程地址格式特定要求如下：url必须以.m3u8结尾
String m3u8Remote2Local(String remoteUrl) {
  var _currentM3u8Md5 = _generateMd5(remoteUrl);
  var _m3u8Name = remoteUrl.substring(remoteUrl.lastIndexOf('/') + 1);
  return localHost + _currentM3u8Md5 + '/' + _m3u8Name;
}

String m3u8Remote2LocalUri(String remoteUrl) {
  var currentM3u8Md5 = _generateMd5(remoteUrl);
  var _m3u8Name = remoteUrl.substring(remoteUrl.lastIndexOf('/') + 1);

  m3u8Name[currentM3u8Md5] =
      remoteUrl.substring(remoteUrl.lastIndexOf('/') + 1);
  if (remoteUrl.contains('http://')) {
    String tmp = remoteUrl.replaceFirst('http://', '');
    m3u8DomainUrl[currentM3u8Md5] =
        'http://' + tmp.substring(0, tmp.indexOf('/'));
  } else if (remoteUrl.contains('https://')) {
    String tmp = remoteUrl.replaceFirst('https://', '');
    m3u8DomainUrl[currentM3u8Md5] =
        'https://' + tmp.substring(0, tmp.indexOf('/'));
  } else {
    m3u8DomainUrl[currentM3u8Md5] =
        remoteUrl.substring(0, remoteUrl.indexOf('/'));
  }

  return '/' + currentM3u8Md5 + '/' + _m3u8Name;
}

String preInitVideoPlay(String remoteUrl) {
  cacheSucReqUrl.clear();
  cacheReqData.clear();
  cacheIdx = 0;
  var currentM3u8Md5 = _generateMd5(remoteUrl);
  m3u8Name[currentM3u8Md5] =
      remoteUrl.substring(remoteUrl.lastIndexOf('/') + 1);
  if (remoteUrl.contains('http://')) {
    String tmp = remoteUrl.replaceFirst('http://', '');
    m3u8DomainUrl[currentM3u8Md5] =
        'http://' + tmp.substring(0, tmp.indexOf('/'));
  } else if (remoteUrl.contains('https://')) {
    String tmp = remoteUrl.replaceFirst('https://', '');
    m3u8DomainUrl[currentM3u8Md5] =
        'https://' + tmp.substring(0, tmp.indexOf('/'));
  } else {
    m3u8DomainUrl[currentM3u8Md5] =
        remoteUrl.substring(0, remoteUrl.indexOf('/'));
  }

  log.i("播放视频转换:" + m3u8Name[currentM3u8Md5]);
  catchingCurTsFrameName = m3u8Name[currentM3u8Md5];
  cancelCurDownloadAndDrop();
  return localHost + currentM3u8Md5 + '/' + m3u8Name[currentM3u8Md5];
}

/// 根据播放器的播放时间来抓取对应的ts片段
catchCurrentTsFrame(int ms) {
  // if (currentM3u8Md5 == null || currentM3u8Md5.isEmpty) {
  //   return;
  // }
  // M3u8Info m3u8info = m3u8InfoMap[currentM3u8Md5];
  // int idx = 0;
  // for (idx = 0; idx < m3u8info.timeList.length; idx++) {
  //   if (m3u8info.timeList[idx] >= ms) {
  //     break;
  //   }
  // }

  // idx =
  //     (idx >= m3u8info.timeList.length) ? (m3u8info.timeList.length - 1) : idx;

  // log.i("索引号码：" + idx.toString());
  // log.i("索引到多少时间片段:" + m3u8info.tsList[idx].toString());

  // catchingCurTsFrameName = m3u8info.tsList[idx];
}

freshCurrentTsFrame(int ms) {
  // if (currentM3u8Md5 == null || currentM3u8Md5.isEmpty) {
  //   return;
  // }
  // M3u8Info m3u8info = m3u8InfoMap[currentM3u8Md5];
  // if (m3u8info == null || m3u8info.timeList == null) {
  //   return;
  // }
  // int idx = 0;
  // for (idx = 0; idx < m3u8info.timeList.length; idx++) {
  //   if (m3u8info.timeList[idx] >= ms) {
  //     break;
  //   }
  // }

  // idx =
  //     (idx >= m3u8info.timeList.length) ? (m3u8info.timeList.length - 1) : idx;

  // log.i("索引号码：" + idx.toString());
  // log.i("索引到多少时间片段:" + m3u8info.tsList[idx].toString());

  // catchingCurTsFrameName = m3u8info.tsList[idx];
}

bool isNeedDrop(String ts) {
  return (catchingCurTsFrameName != ts);
}

String _generateMd5(String data) {
  var _completeM3u8Url = data;
  if (md5sampling != null) {
    data = md5sampling(data);
  }
  var content = Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  var genMd5 = hex.encode(digest.bytes);
  completeM3u8Url[genMd5] = _completeM3u8Url;
  return genMd5;
}
