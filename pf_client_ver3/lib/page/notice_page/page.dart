import 'package:app/config/image_cfg.dart';
import 'package:app/event/index.dart';
import 'package:app/page/notice_page/model/announcement.dart';
import 'package:app/page/spread_page/page.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:app/lang/lang.dart';
import 'package:app/net/net.dart';
import '../../lang/lang.dart';
import 'package:app/utils/screen.dart';

Announcement noticeInfo;

getNoticeInfo() async {
  var resp = await net.request(Routers.ANN_GETLATELYHISTORY_GET, method: 'get');
  if (resp != null && resp.code == 200 && resp.data != null) {
    noticeInfo = Announcement.fromJson(resp.data);
  } else {
    noticeInfo = null;
  }
}

showNoticePage(BuildContext context) {
  if (noticeInfo != null) {
    vibrate();
    showDialog(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NoticePage(
            text: noticeInfo.content,
            // title: noticeInfo.name,
          );
        });
  } else {
    showSpreadPage(context);
  }
}

class NoticePage extends Dialog {
  final String text;
  final String title;
  NoticePage({Key key, @required this.text, this.title = Lang.GONGGAO})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        //保证控件居中效果
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            SizedBox(
              width: s.realW(280),
              height: s.realH(320),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: s.realW(281),
              height: s.realH(360),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: Image(
                      image: AssetImage(ImgCfg.NOTICE_TITLE_TOP),
                    ),
                  ),
                  //CircularProgressIndicator(),
                  Positioned(
                    // padding: const EdgeInsets.only(
                    top: s.realH(70),
                    // ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xff363636),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Positioned(
                    // padding: const EdgeInsets.only(
                    top: s.realH(110),
                    // ),
                    child: SizedBox(
                      width: s.realH(235),
                      height: s.realH(160),
                      child: Scrollbar(
                        // 显示进度条
                        child: SingleChildScrollView(
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    // padding: const EdgeInsets.only(
                    top: s.realH(300),
                    // ),
                    child: FlatButton(
                      color: Color(0xFFFFE03C),
                      padding:
                          EdgeInsets.symmetric(vertical: 7.0, horizontal: 80.0),
                      highlightColor: Colors.yellow[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text(
                        Lang.QUEDING,
                        style:
                            TextStyle(fontSize: 16.0, color: Color(0xFF363636)),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        statusBarEvent.fire(null);
                        showSpreadPage(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
