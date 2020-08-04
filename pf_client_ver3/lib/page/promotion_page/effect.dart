import 'dart:async';
import 'dart:ui';
import 'package:app/utils/utils.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:app/lang/lang.dart';
import 'package:app/config/image_cfg.dart';
import 'package:app/storage/index.dart';
import 'package:app/net/net.dart';
import 'package:permission_handler/permission_handler.dart';
import 'action.dart';
import 'state.dart';

import 'dart:ui' as ui;

Effect<PromotionState> buildEffect() {
  return combineEffects(<Object, Effect<PromotionState>>{
    // PromotionAction.action: _onAction,
    Lifecycle.initState: _onGetShareContent,
    // PromotionAction.onGetShareContent: _onGetShareContent,

    PromotionAction.onCopyClick: _onCopyClick,
    PromotionAction.onSavePicClick: _onSavePicClick,
  });
}

/// 获取推广数据
Future _onGetShareContent(Action action, Context<PromotionState> ctx) async {
  var data = await onGetShareContentNet();
  if (data == null) {
    var str = await ls.get(StorageKeys.SHARE_DATA);
    if (str == null || str.length <= 0) return;
    data = jsonFrom(str);
  }
  ctx.dispatch(PromotionActionCreator.getShareContent(data));
}

/// 复制链接
void _onCopyClick(Action action, Context<PromotionState> ctx) async {
  var code = ctx.state.inviteCode;
  if (code == null || code.length <= 0) return;
  var d = ctx.state.url + "?p=" + ctx.state.inviteCode;
  // print("url:" + d);
  Clipboard.setData(ClipboardData(text: d));
  await showConfirm(ctx.context,
      title: Lang.WENXINTISHI, child: Text(Lang.TIP_CONTENT1));
}

/// 保存图片
Future _onSavePicClick(Action action, Context<PromotionState> ctx) async {
  var img = await drawMaskImage(ImgCfg.MINE_TUIGUANG_BG, Offset(0, 0),
      ctx.state.pipCaptureKey, ctx.state.inviteCode);
  var byteData = await img.toByteData(format: ImageByteFormat.png);
  var pngBytes = byteData.buffer.asUint8List();

  await PermissionHandler()
      .requestPermissions([PermissionGroup.photos, PermissionGroup.storage]);

  ImageGallerySaver.saveImage(pngBytes);
  await showConfirm(ctx.context,
      title: Lang.WENXINTISHI, child: Text(Lang.TIP_CONTENT2));
}

//************************网络***************************************** */
/// 获取推广数据
Future onGetShareContentNet() async {
  var d = await net.request(Routers.SHARE_CONTENT_GET, method: 'get');
  if (d.code != 200) return null;
  return d.data;
}

//*******************************推广保存图片********************************** */
String _url;
ui.Image _image;

Future<ui.Image> _captureImage(GlobalKey pipCaptureKey,
    {double pixelRatio = 1.0}) async {
  RenderRepaintBoundary boundary =
      pipCaptureKey.currentContext.findRenderObject();
  return await boundary.toImage(pixelRatio: pixelRatio);
}

AssetBundle getAssetBundle() => (rootBundle != null)
    ? rootBundle
    : NetworkAssetBundle(Uri.directory(Uri.base.origin));

Future<ui.Image> load(String url) async {
  var stream = AssetImage(url, bundle: getAssetBundle())
      .resolve(ImageConfiguration.empty);

  var completer = Completer<ui.Image>();
  var lsn;
  void listener(ImageInfo frame, bool synchronousCall) {
    final ui.Image image = frame.image;
    // tantan
    if (lsn != null) {
      // print("*********removeListener**********");
      stream.removeListener(lsn);
    }
    completer.complete(image);
  }

  lsn = ImageStreamListener(listener);

  stream.addListener(lsn);

  return completer.future;
}

/// 如果内存已经有，就不在decode
Future<ui.Image> loadImage(String url) async {
  if (_url != null && _url.endsWith(url) && _image != null) {
    return _image;
  }

  _url = url;
  return await load(url);
}

/// mask 图形 和被裁剪的图形 合并
Future<ui.Image> drawMaskImage(String originImageUrl, Offset offset,
    GlobalKey pipCaptureKey, String code) async {
  List<ui.Image> res = await Future.wait([
    //获取裁剪图片
    loadImage(originImageUrl),
    _captureImage(pipCaptureKey, pixelRatio: 2.5),
  ]);

  var paint = Paint();
  var recorder = PictureRecorder();
  var canvas = Canvas(recorder);
  var width = res[0].width;
  var height = res[0].height;
  var w1 = res[1].width;
  //合成
  canvas.drawImage(res[0], offset, paint);
  drawText(canvas, code);
  canvas.drawImage(res[1], Offset((width - w1) / 2.0, 140), paint);
  //生成图片
  return await recorder.endRecording().toImage(width, height);
}

drawText(canvas, String code) {
  var pb = ParagraphBuilder(
    ParagraphStyle(
      textAlign: TextAlign.left,
      // fontWeight: FontWeight.w300,
      // fontStyle: FontStyle.normal,
      fontSize: 28.0,
    ),
  );
  pb.pushStyle(
    ui.TextStyle(
      color: Color(0xff000000),
    ),
  );
  pb.addText(Lang.WODEYAOQINGMA + '\n');
  pb.addText(code);

  var pc = ParagraphConstraints(width: 300);
//这里需要先layout, 后面才能获取到文本高度
  var paragraph = pb.build()..layout(pc);
//文字居中显示
  var offset = Offset(75 * 2.0, 332 * 1.8);
  canvas.drawParagraph(paragraph, offset);
}

//*******************************推广保存图片********************************** */
