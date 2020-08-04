import 'dart:io';

import 'package:app/lang/lang.dart';
import 'package:app/page/main_pao_page/widget/main_pao_mine_page/action.dart';
// import 'package:app/page/portfolio_page/components/portfolioProfile_component/action.dart';
import 'package:app/storage/cache.dart';
import 'package:app/widget/common/toast.dart';
import 'package:app/widget/simple_image_crop/simple_image_crop.dart';
import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/net/net.dart';
import 'package:app/page/edit_person_page/action.dart';
import 'package:app/page/main_mine_page/action.dart';
import 'package:app/widget/common/BasePage.dart';
import 'package:app/widget/common/commonBtn.dart';

import 'state.dart';
import 'dart:convert' as convert;

Widget buildView(
    EditImgState state, Dispatch dispatch, ViewService viewService) {
  return _ExchangePage(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _ExchangePage extends BasePage with BasicPage {
  final EditImgState state;
  final Dispatch dispatch;
  final ViewService viewService;
  final cropKey = GlobalKey<ImgCropState>();
  // final controller = TextEditingController();
  _ExchangePage({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);

  @override
  String screenName() => Lang.YIDONGHESUOFANG;
  List<Widget> actions() => [
        GestureDetector(
          onTap: () {
            Navigator.of(viewService.context).pop();
          },
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(right: 13),
            child: Text(
              Lang.QUXIAO,
              style: TextStyle(color: Color(0xffff5b6f), fontSize: 16),
            ),
          )),
        )
      ];

  Future uploadImage(BuildContext context, File file) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var args = FormData.fromMap(
        {'file': await MultipartFile.fromFile(path, filename: name)});
    if (state.isCover == true) {
      //换背景图
      var resp = await net.request(Routers.EDIT_USER_COVER, args: args);
      if (resp.code != 200) {
        showToast('上传失败，请重新再试!', type: ToastType.negative);
        return;
      }
      //added by jianghe
      var resDataStr = await ls.get(StorageKeys.USERINFO);
      if (resDataStr != null) {
        Map resData = convert.jsonDecode(resDataStr);
        resData['info']['backgroundImg'] = resp.data;
        var str = convert.jsonEncode(resData);
        await ls.save(StorageKeys.USERINFO, str);
      }

      viewService
          .broadcast(MainPaoMineActionCreator.onUpdateUserBgImg(resp.data));
    } else {
      //换头像
      var resp = await net.request(Routers.EDIT_USER_LOGO_POST, args: args);
      if (resp.code != 200) {
        showToast('上传失败，请重新再试!', type: ToastType.negative);
        return;
      }

      //added by jianghe
      var resDataStr = await ls.get(StorageKeys.USERINFO);
      if (resDataStr != null) {
        Map resData = convert.jsonDecode(resDataStr);
        resData['info']['logo'] = resp.data;
        var str = convert.jsonEncode(resData);
        await ls.save(StorageKeys.USERINFO, str);
      }
      viewService.broadcast(EditPersonActionCreator.onGetInfoAction());
      viewService.broadcast(MainMineActionCreator.getInfo());

      viewService
          .broadcast(MainPaoMineActionCreator.onUpdateUserBgImg(resp.data));
    }
    Navigator.of(context).pop();
  }

  Widget _buildCropImage() {
    var _uploadBtnText = Lang.WANCHENG;
    return StatefulBuilder(
      builder: (context, subState) {
        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              ImgCrop(
                key: cropKey,
                chipRadius: 150,
                maximumScale: 3,
                chipShape: state.isCover == true ? 'rect' : 'circle',
                image: FileImage(state.image),
              ),
              Positioned(
                bottom: 50,
                left: (MediaQuery.of(viewService.context).size.width - 307) / 2,
                child: commonBtn(_uploadBtnText, marginTop: 300,
                    tabHandle: () async {
                  subState(() {
                    _uploadBtnText = Lang.SHANGCHUANZHONG;
                  });
                  final crop = cropKey.currentState;
                  final croppedFile = await crop.cropCompleted(state.image,
                      pictureQuality: 900);
                  uploadImage(viewService.context, croppedFile);
                }),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget body() {
    return Center(
      child: state.image != null
          ? _buildCropImage()
          : Expanded(
              child: Text(Lang.TUPIANXUANZEYOUWU),
            ),
    );
  }
}
