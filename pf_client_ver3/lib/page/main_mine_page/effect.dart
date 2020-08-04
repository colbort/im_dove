import 'dart:convert';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/main_mine_page/models/mine_model.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/passcode.dart';
import 'package:app/utils/utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:app/net/net.dart';
import 'package:package_info/package_info.dart';
import 'action.dart';
import 'state.dart';

EventBus updateUserInfo = EventBus();

// Timer getInfoTimer;
Effect<MainMineState> buildEffect() {
  return combineEffects(<Object, Effect<MainMineState>>{
    Lifecycle.initState: _onInit,
    // Lifecycle.didUpdateWidget: _onGetInfo,
    MainMineAction.getInfo: _onGetInfo,
  });
}

void _onInit(Action action, Context<MainMineState> ctx) async {
  // getInfoTimer = Timer.periodic(Duration(milliseconds: 30 * 1000), (e) {
  //   ctx.dispatch(MainMineActionCreator.getInfo());
  // });

  ctx.dispatch(MainMineActionCreator.getInfo());
  var count = await ls.get(StorageKeys.WALLET_TRANSITION);
  var length = int.parse(count == null ? '0' : count);
  var resp = await net.request(Routers.WALLET_GETALLTRANSHISTORY_GET,
      params: action.payload, method: 'get');
  if (resp.code != 200) {
    print('获取交易记录失败!');
    ctx.dispatch(MainMineActionCreator.fetchWalletCount(false));
  } else {
    print('!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`');
    var data = resp.data["data"];
    if (data is List) {
      ctx.dispatch(
          MainMineActionCreator.fetchWalletCount(data.length != length));
    } else if (data == null) {
      ctx.dispatch(MainMineActionCreator.fetchWalletCount(0 != length));
    }
  }
  updateUserInfo.on().listen((event) {
    ctx.dispatch(MainMineActionCreator.getInfo());
  });
  _onAction(action, ctx);
}

void _onGetInfo(Action action, Context<MainMineState> ctx) async {
  var resp = await net.request(Routers.USER_BASE_GET, method: 'get');

  if (resp.data != null && resp.data is Map) {
    var d = MineModel.fromJson(resp.data);
    saveMineModel(d);
    final data =
        await net.request(Routers.CHAT_SIGN_POST, method: "POST", args: {
      "IsVip": false,
      "UserName": resp.data["nickName"],
      "Avatar": resp.data["logo"],
    });
    var map = resp.data;
    map['chatURL'] = data.data['url'];
    resp.data = map;
  }
  if (resp.code == 200) {
    ls.save(StorageKeys.USER_INFO, json.encode(resp.data));
    ctx.dispatch(MainMineActionCreator.saveInfo(resp.data));
  }
}

void _onAction(Action action, Context<MainMineState> ctx) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // FIXED: 统一以是否存在 ${cachePw} 为判断密码锁是否锁定
  final String cachePw = await passcode.request();
  final double cacheImage = await ImgCacheMgr().getCacheRomSize();
  ctx.dispatch(MainMineActionCreator.onSaveImageCache(cacheImage));
  if (packageInfo != null) {
    ctx.dispatch(MainMineActionCreator.onSaveVersion(packageInfo.version));
  }
  if (cachePw != null && cachePw.isNotEmpty) {
    ctx.dispatch(MainMineActionCreator.onChangePwChecked(true));
  } else {
    ctx.dispatch(MainMineActionCreator.onChangePwChecked(false));
  }
}
