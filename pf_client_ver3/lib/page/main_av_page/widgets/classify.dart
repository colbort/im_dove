import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ClassifyWidget extends StatefulWidget {
  final List<ClassifyBean> classify;
  final ValueChanged onClicked;
  final double leftOffset;
  final Color backGroundColor;
  final Color itemColor;
  final double spacing;
  final int currentId;
  final double fontSize;
  final Color fontColor;

  ClassifyWidget({
    @required this.classify,
    @required this.onClicked,
    this.leftOffset = 20,
    this.backGroundColor = Colors.white,
    this.itemColor = Colors.yellow,
    this.spacing = 20,
    this.currentId = 0,
    this.fontSize = 14,
    this.fontColor = Colors.black,
  });
  @override
  _ClassifyWidgetState createState() => _ClassifyWidgetState();
}

class _ClassifyWidgetState extends State<ClassifyWidget> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.pt44,
      color: widget.backGroundColor,
      padding: EdgeInsets.only(left: widget.leftOffset),
      child: ListView(
        // key: _key,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ...List.generate(widget.classify?.length ?? 0, (index) {
            return GestureDetector(
              child: Container(
                // key: _keys[index],
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: widget.spacing),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: widget.currentId == widget.classify[index].id
                        ? widget.itemColor
                        : widget.backGroundColor,
                  ),
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    widget.classify[index].name,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.fontColor,
                    ),
                  ),
                ),
              ),
              onTap: () {
                widget.onClicked(widget.classify[index]);
              },
            );
          })
        ],
      ),
    );
  }
}
