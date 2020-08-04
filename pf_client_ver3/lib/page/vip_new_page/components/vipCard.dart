import 'package:app/page/vip_new_page/action.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class VipItem {
  int day;
  int cardId;
  Color color;
  String name;
  String realPrice; // 真实价格
  String oldPrice; // 原价
  String selectedImg;
  Color borderColor;
  bool isSelected = false;
  VipItem(this.cardId,
      {this.color,
      this.name,
      this.realPrice,
      this.oldPrice,
      this.selectedImg,
      this.borderColor,
      this.isSelected,
      this.day});
}

Widget vipCard(VipItem item, Dispatch dispatch) {
  return GestureDetector(
    onTap: () {
      dispatch(VipActionCreator.selectCard(item.cardId));
    },
    child: Stack(overflow: Overflow.visible, children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: item.cardId == 1 ? 0 : s.realW(8)),
        child: Container(
          width: !item.isSelected ? s.realW(99) : s.realW(115),
          height: !item.isSelected ? s.realH(146) : s.realH(178),
          margin: EdgeInsets.only(top: item.isSelected ? 5 : s.realW(15)),
          decoration: BoxDecoration(
            image: item.isSelected
                ? DecorationImage(
                    image: AssetImage(item.selectedImg), fit: BoxFit.cover)
                : null,
            color: !item.isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: !item.isSelected
                ? Border.all(width: 1, color: item.color)
                : null,
            boxShadow: !item.isSelected
                ? [
                    BoxShadow(
                      color: item.borderColor.withOpacity(0.3),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 4.0,
                    ),
                  ]
                : [],
          ),
          padding: EdgeInsets.symmetric(
              vertical: !item.isSelected ? s.realH(14) : s.realH(34),
              horizontal: s.realW(11)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'VIP',
                style: TextStyle(
                    color: !item.isSelected
                        ? item.color.withOpacity(0.5)
                        : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Text(item.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: !item.isSelected ? Colors.black : Colors.white,
                      )),
                  Text(
                    '卡会员',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: !item.isSelected ? Colors.black : Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: s.realH(16)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '¥',
                          style: TextStyle(
                              color: !item.isSelected
                                  ? item.color.withOpacity(0.5)
                                  : Colors.white70,
                              fontSize: 14),
                        ),
                      ),
                      Text(
                        item.realPrice,
                        style: TextStyle(
                            color: !item.isSelected ? item.color : Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      item.oldPrice != '0'
                          ? Container(
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                item.oldPrice,
                                style: TextStyle(
                                    color: !item.isSelected
                                        ? item.color.withOpacity(0.5)
                                        : Colors.white70,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            )
                          : Container(),
                    ],
                  ))
            ],
          ),
        ),
      ),
      !item.isSelected && item.cardId == 3
          ? Positioned(
              right: -1,
              top: s.realW(13),
              child: Image.asset(
                'assets/vip/chaozhi.png',
                width: 40,
              ),
            )
          : Container()
    ]),
  );
}
