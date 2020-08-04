# 泡芙客户端

基于`Flutter`开发的视频平台

## 环境需求
- Flutter 1.12.x 安装方法差查阅官方()[flutter.dev]
- Dart
- vscode

Flutter 安装完成后，可以执行 `flutter doctor` 检查是否健康。

## 如何开始
- 获取到git仓库
- 进入项目root下
- 执行 `flutter create .` 生成必要文件

```bash
cd client
flutter create .
```

## 基础配置
泡芙的配置，采用的代码直接配置。
配置文件位于`./lib/config`下面的`dart`文件。

- 文件：`config.dart` 

```dart
// 开发模式下设置true，正式发布请设置为false
static const dev = true;
```

## 项目调试
支持android,iOS 虚拟机&真机调试，视频播放模块目前在iOS虚拟机下不支持，视频调试请绕行；
启动虚拟机或者通过数据连上真机调试后，请在vscode的右下角选择设备, 按下F5键进行调试。


## 安卓keystone
位于`/android`目录下
- `./app/key.jks` java生成的`keystore`文件
- `./key.properties` 这里配置`alias`和`password`


## 项目版本
pubspec.yaml中version字段来表示，比如：2.1.2+20  
在xcode中 Version: 2.1.2   Build: 20 
在androidStudio中  versionName: 2.1.2   versionCode: 20
*特别提示：项目打release包，+号后面的数字比上一个release包对应的要加1，不然安卓包覆盖安装会有问题


## 项目打包
*特别提示，打包前请仔细阅读前文中“项目版本”说明；
android请在vscode调试栏Terminal中运行命令  bash ba.sh 会自动生成release包，apk包路径请看输出提示；
iOS请在vscode调试栏Teminal中运行命令 flutter build ios --release --no-codesign  会自动生成xcode工程，xcode工程上的iOS打包流程，请自行查阅教程。


# 版本日志

| ver   |    date    | desc                                        |
| :---- | :--------: | :------------------------------------------ |
| 2.1.0 | 2019/12/19 | `flutter 1.12.13+hotfix.5 • channel stable` |
| 2.0.2 | 2019/12/12 | `flutter 1.12.13+hotfix.5 • channel stable` |
| 2.0.1 | 2019/12/11 | `flutter 1.12.13+hotfix.4 • channel beta`   |
| 2.0.0 | 2019/12/11 | `flutter 1.12.13+hotfix.4 • channel beta`   |


# 开发框架
介绍项目中使用的主要模块

## 数据本地持久化
code path: `./lib/storage`
库引入: import 'package:app/storage/index.dart';
接口使用: ls.get ls.save ls.remove
自定义key值位置: './lib/storage/key.dart'

## 网络图片（自动缓存）
code path: `./lib/image_cache`
库引入: import 'package:app/image_cache/cached_network_image.dart'
接口使用: CachedNetworkImage(imageUrl: xxxurl,cacheManager: ImgCacheMgr(), ...)
特别提示: cacheManager: ImgCacheMgr() 一定要带上，这个主要负责缓存的控制以及图片的解密

## fishRedux
github框架地址：https://github.com/alibaba/fish-redux
入门文档：https://github.com/alibaba/fish-redux/blob/master/doc/README-cn.md
https://www.infoq.cn/article/hTdKPOLumZlUDA*c708e
学习工程：http://usrname:psw@git.fruit.com:8088/zhanqun/learnFishRedux.git
模版代码生成工具：在vscode插件库中搜索fish-redux-template

## 网络请求
code path: `./lib/net`
库引入: import 'package:app/net/net.dart'
接口使用 net.request(String route,{args, String method = 'post', params})
route定义：`./lib/net/routers.dart`

## 数据模型
code path: `./lib/model`
数据模型自动生成，工具说明如下：
  - 工程地址：`http://tantan:tantan387@git.fruit.com:8088/zhanqun/tool-client.git`
  - 工具使用说明:`请查看json2dart/README.md`

## page制作
code path: `./lib/page`
page通过fish-redux-template自动生成模版代码，内部自动生成mvc模式代码，根据需求自行填空相应部分代码
文字相关提取：`./lib/lang/lang.dart`

## 视频模块
基于video_player自定义封装的视频播放器，支持小窗和全屏模式，youtube自由缩放效果

## localserver
基于httpserver实现的服务于播放器的localserver，实现远端流转发和自动缓存，支持短视频自动提前缓存功能

## tf包要修改的地方
合并 tf包的lib、yaml、资源文件
修改 store_chcek中的final.dart  _pkgtype = "填上你跟后台商量好的字符" 这个是与后台商量好的
修改main.dart
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preInitApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (Platform.isAndroid) {
    runApp(InitApp());
  } else {
    String passPkgType = await storeHost.needOnline();
    if (passPkgType == "1") {
      //打开壳
      runApp(getMainPage());
    } else {
      //打开泡芙apps
      //设置泡芙app的icon
      runApp(InitApp());
      final channel = const MethodChannel("com.world/method");
      await channel.invokeMethod('setAppcationIcon', 'appliaction_paofu');
    }
  }
  //如果需要修改代码，请一定仔细检查，逻辑有没有影响调用  await runLocServ(); 这个代码提供播放的功能，所以很重要
  await runLocServ();
}

//壳
Widget getMainPage() {
  final Store<ReduxState> store = StoreContainer.global;
  return MyApp(store: store);
}

// json 构建
build json xxx.g.dart
add : par 'xxx.g.dart'
run: flutter packages pub run build_runner build --delete-conflicting-outputs
