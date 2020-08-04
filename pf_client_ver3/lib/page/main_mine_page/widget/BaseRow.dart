import 'package:app/utils/screen.dart';
import 'package:flutter/material.dart';

typedef TabHandle = void Function();

abstract class BaseRow extends StatelessWidget {
  final Widget icon;
  final String label;
  final TabHandle tabHandle;
  BaseRow({Key key, this.label, this.tabHandle, this.icon}) : super(key: key);
}

mixin BaiceRow on BaseRow {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (tabHandle != null) {
            tabHandle();
          }
        },
        child: Container(
            // color: Colors.white,
            child: GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 52),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: s.realW(22),
                        height: s.realH(22),
                        child: Center(
                          child: icon,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: s.realW(10)),
                        child: Text(
                          label,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  buildRight(),
                ],
              ),
            ),
          ),
        )));
  }

  Widget buildRight();
}

class SetRow extends BaseRow with BaiceRow {
  final bool showArrow;
  final String value;
  final String label;
  final Widget icon;
  SetRow(
      {this.value,
      this.showArrow = false,
      this.label,
      TabHandle tabHandle,
      this.icon})
      : super(label: label, tabHandle: tabHandle, icon: icon);
  @override
  Widget buildRight() {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          value != null
              ? Text(
                  value,
                  style: TextStyle(color: Color(0xff979797), fontSize: 16),
                )
              : Container(),
          showArrow
              ? Icon(Icons.navigate_next,
                  color: Color.fromRGBO(0, 0, 0, 0.5), size: 32)
              : Container(
                  width: 15,
                ),
        ],
      ),
      // onTap: (){
      //   if(tabHandle != null){
      //     tabHandle(label);
      //   }
      // },
    );
  }
}

class SwitchRow extends BaseRow with BaiceRow {
  final Widget icon;
  final String label;
  final bool checked;
  final Function changed;
  SwitchRow({this.checked, this.changed, this.label, @required this.icon})
      : super(label: label, icon: icon);
  @override
  Widget buildRight() {
    return Switch(
      activeColor: Colors.white,
      activeTrackColor: Color(0Xfff9d44f),
      value: checked,
      onChanged: changed,
    );
  }
}
