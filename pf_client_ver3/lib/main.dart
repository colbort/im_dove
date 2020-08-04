// import 'package:app/utils/hosts.dart';
import 'dart:async';

import 'package:app/utils/log.dart';
import 'package:app/utils/logger.dart';

import 'app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loc_server/loc_server.dart';
import 'storage/movie_cache.dart';
import 'storage/shared_pre_util.dart';

main() async {
  log.i('== app main start ==');

  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return Container(color: Colors.transparent);
    };

    // 初始化线程池
    // await Executor().warmUp();
    await preInitApp();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    runApp(InitApp());
    await runLocServ();
    //初始化缓存类
    viewRecord.init();
    sharedPre.init();
  }, onError: (Object obj, StackTrace stack) {
    //添加崩溃日志保存文件
    l.e('ERROR', 'onError happend ...$obj', saveFile: true);
    l.e('ERROR', 'onError happend ...stack:$stack',
        stackTrace: stack, saveFile: true);
    l.writeCrash(obj, stackTrace: stack);
  });

  print('end main');
}
