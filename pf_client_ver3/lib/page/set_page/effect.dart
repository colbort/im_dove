import 'package:fish_redux/fish_redux.dart';
import 'package:package_info/package_info.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'action.dart';
import 'state.dart';
import 'package:app/utils/passcode.dart';

Effect<SetPageState> buildEffect() {
  return combineEffects(<Object, Effect<SetPageState>>{
    // SetPageAction.action: _onAction,
    Lifecycle.initState: _onAction,
    Lifecycle.didUpdateWidget: _onAction
  });
}

void _onAction(Action action, Context<SetPageState> ctx) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // FIXED: 统一以是否存在 ${cachePw} 为判断密码锁是否锁定
  final String cachePw = await passcode.request();
  final double cacheImage = await ImgCacheMgr().getCacheRomSize();
  ctx.dispatch(SetPageActionCreator.onSaveImageCache(cacheImage));
  if (packageInfo != null) {
    ctx.dispatch(SetPageActionCreator.onSaveVersion(packageInfo.version));
  }
  if (cachePw != null && cachePw.isNotEmpty) {
    ctx.dispatch(SetPageActionCreator.onChangePwChecked(true));
  } else {
    ctx.dispatch(SetPageActionCreator.onChangePwChecked(false));
  }
}
