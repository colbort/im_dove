import 'dart:ui';

import 'package:app/config/defs.dart';
import 'package:app/event/index.dart';
import 'package:app/global_store/state.dart';
import 'package:app/global_store/store.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/alicharge_page/page.dart';
import 'package:app/page/boot_page/page.dart';
import 'package:app/page/car_driver_page/page.dart';
import 'package:app/page/edit_img_page/page.dart';
import 'package:app/page/edit_person_page/page.dart';
import 'package:app/page/exchange_page/page.dart';
import 'package:app/page/fan_and_attention_page/page.dart';
import 'package:app/page/main_av_page/page.dart';
import 'package:app/page/main_page/page.dart';
import 'package:app/page/main_pao_page/widget/main_pao_detail_page/page.dart';
import 'package:app/page/main_pao_page/widget/main_pao_other_page/page.dart';
import 'package:app/page/main_pao_page/widget/main_pao_play_page/page.dart';
import 'package:app/page/mine_channel_page/page.dart';
import 'package:app/page/noticeList_page/page.dart';
import 'package:app/page/nv_detail_page/page.dart';
import 'package:app/page/phone_page/page.dart';
import 'package:app/page/promotion_page/page.dart';
import 'package:app/page/ruler_page/page.dart';
import 'package:app/page/set_page/page.dart';
import 'package:app/page/universal_page/page.dart';
import 'package:app/page/upload_notice_page/page.dart';
import 'package:app/page/upload_vedio_page/page.dart';
import 'package:app/page/vip_new_page/page.dart';
import 'package:app/page/wallet_page/page.dart';
import 'package:app/page/webview_page/page.dart';
import 'package:app/player/video_page/page.dart';
import 'package:app/umplus/umplus.dart' as umplus;
import 'package:app/utils/comm.dart';
import 'package:app/utils/flutter_sys_core/im_router.dart';
import 'package:app/utils/logger.dart';
import 'package:app/utils/passcode.dart';
import 'package:app/utils/screen.dart';
import 'package:app/widget/common/boot_pw_page/page.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action;
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';

import 'loc_server/loc_server.dart';
import 'page/search_page/page.dart';
import 'utils/utils.dart';
import 'widget/common/toast/oktoast.dart';

var lock = false;
//切后台时间
var toBackTime = 0;
preInitApp() async {
  log.d('-- app inited-- ');
  var code = await passcode.request();
  if (code == null || code.isEmpty) {
    lock = false;
  } else {
    lock = true;
  }
}

/// 创建应用的根 Widget
/// 1. 创建一个简单的路由，并注册页面
class InitApp extends StatefulWidget {
  //statusBar设置为透明，去除半透明遮罩
  final style = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  @override
  InitAppState createState() => InitAppState();
}

class InitAppState extends State<InitApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
// Widget createApp() {

  InitAppState({var lock = false});

  //MARK:判断是否已添加悬浮窗
  var _added = false;

  //不需要放大左滑退出页面的路由表
  final noLeftSliderRoutes = [
    page_video,
    page_main_pao_play,
  ];

  final routes = PageRoutes(
      pages: <String, Page<Object, dynamic>>{
        /// 注册TodoList主页面
        page_main: MainPage(),
        page_video: VideoPage(),
        page_search: SearchPage(),
        page_setPage: SetPage(),
        page_boot: BootPage(),
        page_bootPw: BootPwPage(),
        page_noticeList: NoticeListPage(),
        page_phone: PhonePage(),
        page_vipNewPage: VipNewPage(),
        page_walletPage: WalletPage(),
        page_alichargePage: AlichargePage(),
        page_mineChannelPage: MineChannelPage(),
        page_mineCarDiver: CarDriverPage(),
        page_mineExchange: ExchangePage(),
        page_mineEditPerson: EditPersonPage(),
        page_mineEditImage: EditImgPage(),
        page_promotionpage: PromotionPage(),
        page_webviewPage: WebviewPage(),
        page_univerdalPage: UniverdalPage(),
        page_rulerPage: RulerPage(),
        page_uploadVedioPage: UploadVedioPage(),
        page_uploadNoticePage: UploadNoticePage(),
        page_fanAndAttentionPage: FanAndAttentionPage(),
        page_nvDetailPage: NvDetailPage(),
        'main_av_page': MainAvPage(),
        page_main_pao_other: MainPaoOtherPage(),
        page_main_pao_play: MainPaoPlayPage(),
        page_main_pao_detail: MainPaoDetailPage(),
      },
      visitor: (String path, Page<Object, dynamic> page) {
        /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
        /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
        if (page.isTypeof<GlobalBaseState>()) {
          /// 建立 AppStore 驱动 PageStore 的单向数据连接
          /// 1. 参数1 AppStore
          /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
          page.connectExtraStore<GlobalState>(GlobalStore.store,
              (Object pagestate, GlobalState appState) {
            final GlobalBaseState p = pagestate;
            if (p.themeColor != appState.themeColor) {
              if (pagestate is Cloneable) {
                final Object copy = pagestate.clone();
                final GlobalBaseState newState = copy;
                newState.themeColor = appState.themeColor;
                return newState;
              }
            }
            return pagestate;
          });
        }

        /// AOP
        /// 页面可以有一些私有的 AOP 的增强， 但往往会有一些 AOP 是整个应用下，所有页面都会有的。
        /// 这些公共的通用 AOP ，通过遍历路由页面的形式统一加入。
        page.enhancer.append(
          /// View AOP
          viewMiddleware: <ViewMiddleware<dynamic>>[
            safetyView<dynamic>(),
          ],

          /// Adapter AOP
          adapterMiddleware: <AdapterMiddleware<dynamic>>[
            safetyAdapter<dynamic>()
          ],

          /// Effect AOP
          effectMiddleware: <EffectMiddleware<dynamic>>[
            _pageAnalyticsMiddleware<dynamic>(),
          ],

          /// Store AOP
          middleware: <Middleware<dynamic>>[
            logMiddleware<dynamic>(tag: page.runtimeType.toString()),
          ],
        );
      });
  // final routeObserver = RouteObserver<PageRoute>();
  final routeObserver = CustomedRouteObserver<PageRoute>();
  bool isShowPw;

  @override
  void initState() {
    s.init();
    isShowPw = false;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.i("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        appUnFocusEventBus.fire(null);
        umplus.uploadOperation();
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        appUnFocusEventBus.fire(null);
        log.i("切换到前台");
        var nowTime = DateTime.now().millisecondsSinceEpoch;
        log.i('nowTime:' + nowTime.toString());
        log.i('gap:' + (nowTime - toBackTime).toString());
        if (nowTime - toBackTime > 60000) {
          resetServerState();
        }

        if (nowTime - toBackTime > 2 * 60 * 1000) {
          isResumed = true;
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        toBackTime = DateTime.now().millisecondsSinceEpoch;
        log.i('toBackTime:' + toBackTime.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appPausedEventBus.fire(null);
          setState(() {
            isShowPw = true;
          });
        });
        break;

      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  //MARK:build
  Widget build(BuildContext context) {
    //将style设置到app
    SystemChrome.setSystemUIOverlayStyle(widget.style);
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .copyWith(textScaleFactor: 1),
      child: OKToast(
        ///全局设置隐藏前的属性,这里设置后,每次当你显示新的 toast 时,旧的就会被关闭
        dismissOtherOnShow: true,
        child: MaterialApp(
          // debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true, // 开启
          // checkerboardOffscreenLayers: true
          // // 使用了saveLayer的图形会显示为棋盘格式并随着页面刷新而闪烁
          // checkerboardRasterCacheImages:
          //     true, // 做了缓存的静态图片在刷新页面时不会改变棋盘格的颜色；如果棋盘格颜色变了说明被重新缓存了，这是我们要避免的

          navigatorKey: navigatorKey,
          theme: ThemeData(
            primaryColor: const Color(0xffffe300),
            platform: TargetPlatform.iOS,
            primarySwatch: Colors.blue,
            cursorColor: const Color(0xffffe300),
            cupertinoOverrideTheme: const CupertinoThemeData(
              primaryColor: Color(0xffffe300),
            ),
          ),
          // home: routes.buildPage('main', null),
          home: LayoutBuilder(
            builder: (context, constraints) {
              if (!_added) {
                _added = true;
                // WidgetsBinding.instance
                //     .addPostFrameCallback((_) => _insertOverlay(context));
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _insertBgPwOverlay(context));
              }

              s.reset();
              return routes.buildPage('boot', {"isPwing": lock});
              // return routes.buildPage('main_av_page', null);
            },
          ),
          navigatorObservers: [routeObserver],
          // onGenerateRoute: (RouteSettings settings) {
          //   return MaterialPageRoute<Object>(builder: (BuildContext context) {
          //     return routes.buildPage(settings.name, settings.arguments);
          //   });
          // },
          /// 重写系统router 优化左边滑动体验
          onGenerateRoute: (RouteSettings settings) {
            if (noLeftSliderRoutes.contains(settings.name)) {
              return MaterialPageRoute<Object>(builder: (BuildContext context) {
                return routes.buildPage(settings.name, settings.arguments);
              });
            } else {
              return IMCupertinoPageRoute<Object>(
                  builder: (BuildContext context) {
                return routes.buildPage(settings.name, settings.arguments);
              });
            }
          },
        ),
      ),
    );
  }

  _insertBgPwOverlay(BuildContext context) async {
    return Overlay.of(context).insert(OverlayEntry(
      builder: (context) {
        return routes.buildPage('bootPw', {
          'inputTitle': Lang.INPUTPWD,
          'appBarTitle': '',
          'isShow': lock,
          'isShowAppBar': false,
          'pwType': PwPageType.pwConfirm
        });
      },
    ));
  }
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          log.i('${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}

//继承RouteObserver
class CustomedRouteObserver<PageRoute> extends RouteObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    dismissAllToast();
    // 当调用Navigator.pop时回调
    super.didPop(route, previousRoute);
    //可通过route.settings获取路由相关内容
    //route.currentResult获取返回内容
    // print(route.settings.name);
  }
}
