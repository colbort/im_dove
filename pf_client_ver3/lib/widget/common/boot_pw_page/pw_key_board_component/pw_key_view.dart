import 'package:flutter/material.dart';

class PwKeyWight extends StatelessWidget {
  const PwKeyWight({
    Key key,
    @required this.sNum,
    @required this.onPressCb,
    this.sChar = "",
  })  : assert(onPressCb != null),
        assert(sNum != null && sNum != ""),
        super(key: key);

  final String sNum;
  final String sChar;
  final onPressCb;

  @override
  Widget build(BuildContext context) {
    final double clientWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _customRealW(50, clientWidth),
      width: _customRealW(112, clientWidth),
      margin: EdgeInsets.symmetric(
          horizontal: _customRealW(2, clientWidth),
          vertical: _customRealW(3, clientWidth)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                offset: Offset(0, 2), //阴影xy轴偏移量
                blurRadius: 4, //阴影模糊程度
                spreadRadius: 0 //阴影扩散程度
                )
          ]),
      child: FlatButton(
        child: Center(
          child: Text(
            sNum,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
        ),
        onPressed: () {
          onPressCb(sNum);
        },
      ),
    );
  }

  _customRealW(double w, double clientWidth) {
    return clientWidth / 360 * w;
  }
}
