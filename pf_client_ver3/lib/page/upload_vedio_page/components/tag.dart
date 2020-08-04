import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTag(String name, bool selected,
    {Function onTapHandle, Function closeHandle}) {
  return GestureDetector(
    onTap: onTapHandle,
    child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          color: selected
              ? getFlagColors(name)['b']
              : Colors.grey.withOpacity(0.2),
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              child: Text(
                name,
                style: TextStyle(
                    color: selected ? getFlagColors(name)['t'] : Colors.grey,
                    fontSize: 10),
              ),
            ),
          ],
        )),
  );
}

class BuildcustomTag extends StatefulWidget {
  final String name;
  final bool selected;
  final Function onSubmitted;
  BuildcustomTag(this.name, this.selected, this.onSubmitted);
  @override
  _BuildcustomTagState createState() => _BuildcustomTagState();
}

class _BuildcustomTagState extends State<BuildcustomTag> {
  TextEditingController _customController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        var v = _customController.value.text;
        if (v.isNotEmpty && v.length <= 5) {
          widget.onSubmitted(v);
          _customController.text = '';
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color isSelectedColor = widget.selected ? Color(0xffffe300) : Colors.grey;
    return Container(
      alignment: Alignment.center,
      width: s.realW(90),
      height: s.realH(23),
      padding: EdgeInsets.symmetric(horizontal: s.realH(10)),
      decoration: BoxDecoration(
        color: isSelectedColor.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 12),
        inputFormatters: [
          WhitelistingTextInputFormatter(
              RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")), //只能輸入漢字或者字母或數字
          LengthLimitingTextInputFormatter(5), //最大長度
        ],
        maxLength: 5,
        autofocus: false,
        controller: _customController,
        focusNode: _focusNode,
        decoration: InputDecoration(
            hintText: "#自定义标签",
            hintStyle: TextStyle(fontSize: s.realW(9)),
            border: InputBorder.none,
            counterText: ""),
      ),
    );
  }
}
