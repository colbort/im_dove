import 'dart:convert';

// import 'package:app/page/portfolio_page/components/portfolioProfile_component/action.dart';
import 'package:app/storage/cache.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:app/widget/common/toast.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/page/main_mine_page/action.dart';
import 'package:app/page/set_page/components/BaseRow.dart';
import 'package:app/widget/common/BasePage.dart';
import 'action.dart';
import 'state.dart';
import 'dart:convert' as convert;

Widget buildView(
    EditPersonState state, Dispatch dispatch, ViewService viewService) {
  return _EditPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _EditPageView extends BasePage with BasicPage {
  final EditPersonState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _EditPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);

  @override
  String screenName() => Lang.BIANJIZILIAO;

  Widget _labelRow(String labelText) {
    return Padding(
        child: Text(
          labelText,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        padding: EdgeInsets.all(14));
  }

  Widget _splitLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  Future<bool> _checkSensitive(String text) async {
    var _cacheList = await ls.get(StorageKeys.SENSITIVE_LIST);
    if (_cacheList != null && json.decode(_cacheList).contains(text)) {
      return false;
    }

    if (_cacheList == null) {
      var _reqList = (await net.request(Routers.EDIT_USER_SENSITIVE));
      if (_reqList.data != null) {
        ls.save(StorageKeys.SENSITIVE_LIST, json.encode(_reqList));
        if (_reqList.data.contains(text)) {
          return false;
        }
      }
    }

    return true;
  }

  void _openNameDialog() async {
    var ctl = TextEditingController(text: state.nickName);
    var ok = await showConfirm(
      viewService.context,
      title: Lang.XIUGAINICHEN,
      hasCancel: true,
      child: TextField(
        controller: ctl,
        maxLength: 10,
        decoration: InputDecoration(
          hintText: Lang.QINGSHURUNICHEN,
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white, style: BorderStyle.solid)),
        ),
      ),
    );

    if (ok) {
      /// 敏感词
      bool _c = await _checkSensitive(ctl.text);
      if (!_c) {
        showToast(Lang.SISENTIVE_HINT, type: ToastType.negative);
        return;
      }
      // ok
      await net
          .request(Routers.EDIT_USER_INFO_POST, args: {'nickName': ctl.text});
      var resDataStr = await ls.get(StorageKeys.USERINFO);
      if (resDataStr != null) {
        Map resData = convert.jsonDecode(resDataStr);
        resData['info']['nickName'] = ctl.text;
        var str = convert.jsonEncode(resData);
        await ls.save(StorageKeys.USERINFO, str);
      }
      viewService.broadcast(MainMineActionCreator.getInfo());
      dispatch(EditPersonActionCreator.onChangeName(ctl.text));
    }
  }

  void _openSexDialog(state) async {
    var gender = state.gender;
    bool ok = await showConfirm(viewService.context, hasCancel: true,
        child: StatefulBuilder(
      builder: (context, subState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                gender = 2;
                subState(() {});
              },
              child: SvgPicture.asset(
                gender == 2 ? 'assets/mine/nan.svg' : 'assets/mine/nan1.svg',
                width: 84,
                height: 84,
                fit: BoxFit.fill,
              ),
            ),
            GestureDetector(
              onTap: () {
                gender = 1;
                subState(() {});
              },
              child: SvgPicture.asset(
                gender == 1 ? 'assets/mine/nv.svg' : 'assets/mine/nv1.svg',
                width: 84,
                height: 84,
                fit: BoxFit.fill,
              ),
            ),
          ],
        );
      },
    ));
    if (ok) {
      await net.request(Routers.EDIT_USER_INFO_POST, args: {'gender': gender});

      //added by jianghe
      var resDataStr = await ls.get(StorageKeys.USERINFO);
      if (resDataStr != null) {
        Map resData = convert.jsonDecode(resDataStr);
        resData['info']['gender'] = gender;
        var str = convert.jsonEncode(resData);
        await ls.save(StorageKeys.USERINFO, str);
      }
      viewService.broadcast(MainMineActionCreator.getInfo());
      dispatch(EditPersonActionCreator.onChangeGender(gender));
    }
  }

  @override
  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _HeadImg(viewService.context, state),
        _labelRow(Lang.JIBENXINXI),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: SetRow(
            value: state.nickName,
            showArrow: true,
            label: Lang.NICHEN,
            tabHandle: () {
              _openNameDialog();
            },
          ),
        ),
        _splitLine(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: SetRow(
              value: state.gender == 1 ? Lang.NV : Lang.NAN,
              showArrow: true,
              label: Lang.SEX,
              tabHandle: () {
                _openSexDialog(state);
              }),
        ),
        _splitLine()
      ],
    );
  }
}

class _HeadImg extends StatefulWidget {
  final BuildContext context;
  final EditPersonState state;
  _HeadImg(this.context, this.state);
  @override
  __HeadImgState createState() => __HeadImgState();
}

// enum _sheetType { gallery, camera }

class __HeadImgState extends State<_HeadImg> {
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Navigator.of(widget.context)
        .pushNamed('mineEditImage', arguments: {'image': image});
  }

  // void _showActionSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SafeArea(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min, // 设置最小的弹出
  //             children: <Widget>[
  //                ListTile(
  //                 leading:  Icon(Icons.photo_camera),
  //                 title:  Text("相机拍照"),
  //                 onTap: () async {
  //                   getImage(_sheetType.camera);
  //                 },
  //               ),
  //                ListTile(
  //                 leading:  Icon(Icons.photo_library),
  //                 title:  Text("相册选择"),
  //                 onTap: () async {
  //                   getImage(_sheetType.gallery);
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2.0,
      child: GestureDetector(
        onTap: () {
          getImage();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(84))),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: widget.state.logo == ''
                      ? SvgPicture.asset(
                          'assets/mine/default_man.svg',
                          width: 84,
                          height: 84,
                          fit: BoxFit.fill,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.state.logo,
                          cacheManager: ImgCacheMgr(),
                          width: 84,
                          height: 84,
                          fit: BoxFit.fill,
                        ),
                ),
                Positioned(
                  height: 28,
                  width: 84,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(55, 111, 255, 0.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100))),
                    child: Text(
                      Lang.GAITOUXIANG,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
