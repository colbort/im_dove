import 'package:app/config/image_cfg.dart';
import 'package:app/event/index.dart';
import 'package:app/lang/lang.dart';
import 'package:app/storage/cache.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String assUrl =
    'https://fs.lhexm.com/image/ch/ij/cp/d9/a805ddb5a7804792b701a660dc709337.mobileconfig';

/// 小助手弹窗
assistantDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () async {
                          var _nowNum = await ls.get(StorageKeys.ASS_NUM);
                          await ls.save(StorageKeys.ASS_FLAG,
                              DateTime.now().millisecondsSinceEpoch.toString());
                          await ls.save(
                              StorageKeys.ASS_NUM,
                              _nowNum == null
                                  ? (0).toString()
                                  : (int.parse(_nowNum) + 1).toString());
                          statusBarEvent.fire(null);
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        ImgCfg.ASS_TEXT,
                        width: 160,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 22),
                      child: Image.asset(
                        ImgCfg.ASS_PIC,
                        width: 160,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 26),
                      child: Text(Lang.ASS_TEXT,
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(51, 51, 51, 0.8))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Image.asset(
                        ImgCfg.ASS_LINE,
                        width: 200,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await ls.save(StorageKeys.ASS_FLAG, 'true');
                        Navigator.of(context).pop();
                        await launch(assUrl);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 35, bottom: 28),
                        child: Image.asset(
                          ImgCfg.ASS_BTN,
                          width: 154,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
