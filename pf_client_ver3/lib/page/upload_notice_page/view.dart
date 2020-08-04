import 'package:app/lang/lang.dart';
import 'package:app/page/upload_notice_page/state.dart';
import 'package:app/page/upload_vedio_page/components/label.dart';
import 'package:app/storage/cache.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../widget/common/BasePage.dart';

Widget buildView(
    UploadNoticeState state, Dispatch dispatch, ViewService viewService) {
  return _UploadVedioView(
      dispatch: dispatch, state: state, viewService: viewService);
}

class _UploadVedioView extends BasePage with BasicPage {
  final UploadNoticeState state;
  final Dispatch dispatch;
  final ViewService viewService;

  _UploadVedioView({Key key, this.dispatch, this.state, this.viewService})
      : super(key: key);
  String screenName() => '上傳須知';

  @override
  Widget body() {
    return Stack(children: <Widget>[
      Container(
        // color: Colors.red,
        child: Column(children: <Widget>[
          homeLabel(
            text: '上傳規則',
            subtitle: '',
          ),
          Container(
            width: s.realW(340),
            alignment: Alignment.topLeft,
            child: Text(
              Lang.SHANGCHUANGUIZE,
              style: TextStyle(fontSize: 14),
            ),
          ),
          homeLabel(
            text: '上傳說明',
            subtitle: '',
          ),
          Container(
            width: s.realW(340),
            alignment: Alignment.topLeft,
            child: Text(
              Lang.SHANGCHUANSHUOMING,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ]),
      ),
      Positioned(
          bottom: 30,
          left: s.realW(35),
          child: Center(
            child: Container(
                width: s.realW(300),
                height: s.realH(30),
                child: FlatButton(
                  child: Text("我已閱讀並同意"),
                  color: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  onPressed: () async {
                    await ls.save(StorageKeys.UPDATEVD_AGREE, '');
                    Navigator.of(viewService.context).pop(true);
                    // Navigator.pop(viewService.context);
                  },
                )),
          ))
    ]);
  }
}
