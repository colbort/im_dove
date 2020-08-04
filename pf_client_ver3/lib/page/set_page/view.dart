import 'package:app/utils/logger.dart';
import 'package:app/widget/common/confirm.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:app/config/defs.dart';
import 'package:app/lang/lang.dart';
import 'package:app/image_cache/cached_network_image.dart';
import '../../widget/common/BasePage.dart';
import './components/BaseRow.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    SetPageState state, Dispatch dispatch, ViewService viewService) {
  return _SetPageView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _SetPageView extends BasePage with BasicPage {
  final SetPageState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _SetPageView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => Lang.SHEZHI;

  Widget _labelRow(String labelText) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(216, 216, 216, 0.2),
          border: Border(
              top: BorderSide(
                  width: 0.5, color: Color.fromRGBO(25, 25, 25, 0.21)),
              bottom: BorderSide(
                  width: 0.5, color: Color.fromRGBO(25, 25, 25, 0.21)))),
      width: double.infinity,
      child: Padding(
        child: Text(
          labelText,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _splitLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: 0.5,
        color: Color.fromRGBO(25, 25, 25, 0.21),
      ),
    );
  }

  void _pwSwitchHandle(bool checked) {
    log.i(checked);
    if (checked) {
      Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
        'inputTitle': Lang.INPUTPWDWILL,
        'appBarTitle': Lang.SETPASSOCDE,
        'isShowAppBar': true,
        'pwType': PwPageType.setPw
      });
    } else {
      Navigator.of(viewService.context).pushNamed('bootPw', arguments: {
        'inputTitle': Lang.INPUTPWD,
        'appBarTitle': Lang.REMOVEPASSCODE,
        'isShowAppBar': true,
        'pwType': PwPageType.delPw
      });
    }
    // dispatch(SetPageActionCreator.onChangePwChecked(checked));
  }

  void _cacheClean() async {
    var ok = await showConfirm(viewService.context,
        title: Lang.TIPS, child: Text(Lang.TIPS1));
    if (ok) {
      await ImgCacheMgr().emptyCache();
      dispatch(SetPageActionCreator.onSaveImageCache(0));
    }
  }

  @override
  Widget body() {
    final _imgCache = (state.imageCache / 1024 / 1024).floorToDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _labelRow(Lang.ACCOUNTANDSAFE),
        SetRow(
            value: state.phoneNumber.length > 8
                ? state.phoneNumber.replaceRange(4, 8, '****')
                : '',
            showArrow: true,
            tabHandle: () {
              Navigator.of(viewService.context).pushNamed('phone',
                  arguments: {'oldPhone': state.phoneNumber});
            },
            label: Lang.SHOUJIHAO),
        _labelRow(Lang.YINSI),
        SwitchRow(
            label: Lang.MIMASUO,
            changed: _pwSwitchHandle,
            checked: state.pwChecked),
        _labelRow(Lang.QITA),
        SetRow(value: '9898huge9898@gmail.com', label: Lang.OFFICALEMAIL),
        _splitLine(),
        SetRow(
          value: '${_imgCache}M',
          label: Lang.CLEANCACHE,
          tabHandle: this._cacheClean,
        ),
        _splitLine(),
        SetRow(value: state.version, label: Lang.VERSIONNUM),
        _splitLine(),
      ],
    );
  }
}
