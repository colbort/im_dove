import 'package:app/config/image_cfg.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/umplus/umplus.dart' as umplus;

class TitleBar extends StatefulWidget {
  final List<String> types;
  final ValueChanged onTap;
  TitleBar({
    this.types,
    this.onTap,
  });
  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  var pages;
  var buttons;
  var current;
  var initialScrollOffset;
  var pageController;
  var scrollController;
  final i30 = s.realW(30);

  @override
  void initState() {
    super.initState();
    current = 0;
    initialScrollOffset = 0.0;
    pageController = PageController(initialPage: current);
    scrollController = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {});
    });
    _buildPages();
    return Container(
      height: Dimens.pt44,
      width: Dimens.ptRealW,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              children: pages,
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.topRight,
              width: Dimens.pt40,
              height: Dimens.pt30,
              child: SvgPicture.asset(
                ImgCfg.COMMON_SEARCH,
                width: Dimens.pt30,
                height: Dimens.pt30,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              umplus
                  .event(umplus.Events.pvavvsousuo, needRecordOperation: false)
                  .sendEvent();
              Navigator.of(context)
                  .pushNamed('searchMain', arguments: {"type": 1});
            },
          )
        ],
      ),
    );
  }

  void _buildPages() {
    pages = List<Widget>();
    buttons = List<Widget>();

    pages.addAll([
      ...List.generate(widget.types.length, (index) {
        return Container(
          height: Dimens.pt44,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                  alignment: Alignment.bottomRight,
                  child: Text(widget.types[index]),
                ),
                Positioned(
                  left: 5,
                  bottom: 3,
                  child: Visibility(
                    visible: current == index,
                    child: Container(
                      height: 5,
                      width: widget.types[index].length * 1.4 * 12,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                current = index;
              });
              if (widget.onTap != null) {
                widget.onTap(widget.types[index]);
              }
              _updateStatus(index, widget.types[index].length, true);
            },
          ),
        );
      }),
    ]);
  }

  void _updateStatus(int index, int length, bool slide) {
    setState(() {
      var temp = current;
      current = index;
      if ((temp - current).abs() == 1 || slide) {
        // checkeds.updateAll((index, checked) {
        //   if (current == index) {
        //     return true;
        //   }
        //   return false;
        // });
      }

      if (!slide) {
        pageController
          ..animateToPage(
            current,
            duration: Duration(milliseconds: 500 * (temp - current).abs()),
            curve: Curves.ease,
          );
      }
      scrollController
        ..jumpTo(
          (current - 2) * length * 1.5 * 12,
        );
    });
  }
}