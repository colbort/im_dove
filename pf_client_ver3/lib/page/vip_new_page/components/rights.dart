import 'package:app/page/vip_new_page/components/vipCard.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

import 'btn.dart';

Widget rightCard(VipItem item, String day, {Function onTap}) {
  List _getRights(String day) => [
        {
          'img': 'assets/vip/day.png',
          'title': '有效日期',
          'bigTitle': day,
          'isShow': true
        },
        {
          'img': 'assets/vip/vip.png',
          'title': 'VIP特權',
          'bigTitle': '標誌',
          'isShow': true
        },
        {
          'img': 'assets/vip/famale.png',
          'title': 'VIP特享',
          'bigTitle': '頭像框',
          'isShow': true
        },
        {
          'img': 'assets/vip/heart.png',
          'title': '永不掉簽',
          'bigTitle': '超級簽',
          'isShow': item.cardId == 3
        },
      ];
  return Container(
    height: s.realH(344),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: Offset(0.0, 2.0),
          blurRadius: 12.0,
        ),
      ],
    ),
    child: Stack(
      overflow: Overflow.visible,
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(
          top: s.realH(15),
          child: Image.asset(
            'assets/vip/stack1.png',
            width: 180,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: s.realH(27)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: s.realH(30)),
                child: Text(
                  item.name != null ? item.name + '卡會員特權' : '卡會員特權',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Wrap(
                // spacing: 50,
                runSpacing: 30,
                children: <Widget>[
                  ..._getRights('$day天').map((r) => r['isShow']
                      ? Container(
                          width: s.realW(150),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                r['img'],
                                width: s.realH(55),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(r['title']),
                                  Text(
                                    r['bigTitle'],
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      : SizedBox())
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: s.realH(35)),
                child: vipBtn(onTap: onTap),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
