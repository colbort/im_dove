import 'dart:math';

import 'package:app/net/net.dart';
import 'package:app/storage/cache.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<UploadVedioState> buildEffect() {
  return combineEffects(
      <Object, Effect<UploadVedioState>>{Lifecycle.initState: _initState});
}

void _initState(Action action, Context<UploadVedioState> ctx) async {
  // await ls.save(StorageKeys.UPDATEVD_AGREE, 'agree');
  final isAgree = await ls.get(StorageKeys.UPDATEVD_AGREE) ?? '';
  ctx.dispatch(
      UploadVedioActionCreator.updateAgree(isAgree.toString().isEmpty));
  int moneyLabe = 0;
  ctx.dispatch(UploadVedioActionCreator.moneyLabe(moneyLabe));
  final resp =
      await net.request(Routers.VIDEO_ALLVIDEOTAG_POST, args: {'location': 2});
  if (resp.code == 200) {
    var tags = List.from(resp.data.sublist(
      0,
      min<int>(resp.data.length, 20),
    ));
    ctx.dispatch(UploadVedioActionCreator.onSaveTags(tags));
  }
}
