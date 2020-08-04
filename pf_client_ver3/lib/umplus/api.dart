import 'dart:io';
import 'package:app/net/net.dart';
import 'package:app/utils/version.dart';
import 'package:flutter_umplus/flutter_umplus.dart';

//无数据操作
class OperationBase {
  String name; //发送给第三方umeng的id
  String id; //发送给自己后端的id
  int gap; //上一次操作时间间隔
  bool hasData;
  dynamic data;

  String toJson() {
    var _data = {};
    _data["id"] = id;
    _data["gap"] = gap;
    if (hasData) {
      _data["data"] = data.toString();
    }

    return _data.toString();
  }

  sendEvent() {
    if (isDebug()) return;
    if (hasData) {
      FlutterUmplus.event(name, label: data.toString());
    } else {
      FlutterUmplus.event(name);
    }
  }
}

//操作记录
List operation = List();
int lastOperationTime = 0;

bool isDebug() {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
}

uploadOperation() {
  if (isDebug()) return;
  if (operation.length == 0) return;
  var data = {};
  data['os'] = Platform.operatingSystem;
  data['osVersion'] = Platform.operatingSystemVersion;
  data['channel'] = 'official';
  data['version'] = version.versionLocal;

  List<String> _operation = List();
  operation.forEach((v) {
    _operation.add(v.toJson());
  });
  data['operation'] = _operation;

  net.request(Routers.USEROPERA_ADD, args: data);
  operation.clear();
}

Future<bool> init(
  String key,
  String channel, {
  bool reportCrash = true,
  bool encrypt = false,
  bool logEnable = false,
}) async {
  if (isDebug()) return false;
  return FlutterUmplus.init(key,
      channel: channel,
      reportCrash: reportCrash,
      encrypt: encrypt,
      logEnable: logEnable);
}

// /// 打开页面时进行统计
// /// [name]
// Future<Null> beginPageView(String name) async {
//   var pv = OperationBase();
//   pv.id = 'pv_begin_' + name;
//   if (lastOperationTime == 0) {
//     pv.gap = 0;
//   } else {
//     var now = DateTime.now().millisecondsSinceEpoch;
//     pv.gap = (now - lastOperationTime) ~/ 1000;
//     lastOperationTime = now;
//   }
//   operation.add(pv);
//   FlutterUmplus.beginPageView(name);
// }

// /// 关闭页面时结束统计
// /// [name]
// Future<Null> endPageView(String name) async {
//   var pv = OperationBase();
//   pv.id = 'pv_end_' + name;
//   if (lastOperationTime == 0) {
//     pv.gap = 0;
//   } else {
//     var now = DateTime.now().millisecondsSinceEpoch;
//     pv.gap = (now - lastOperationTime) ~/ 1000;
//     lastOperationTime = now;
//   }
//   operation.add(pv);
//   FlutterUmplus.endPageView(name);
// }

/// 计数事件统计
/// [eventId]  当前统计的事件ID
/// [label] 事件的标签属性
OperationBase event(String name,
    {dynamic data, bool needRecordOperation = true}) {
  var hasData = (data != null);
  var ev = OperationBase();
  ev.hasData = hasData;
  if (hasData) {
    ev.data = data;
  }

  ev.id = 'ev_' + name;
  ev.name = name;
  if (lastOperationTime == 0) {
    ev.gap = 0;
    lastOperationTime = DateTime.now().millisecondsSinceEpoch;
  } else {
    var now = DateTime.now().millisecondsSinceEpoch;
    ev.gap = (now - lastOperationTime) ~/ 1000;
    lastOperationTime = now;
  }
  if (needRecordOperation) {
    operation.add(ev);

    if (operation.length > 50) {
      operation.removeAt(0);
    }
  }

  return ev;
}
