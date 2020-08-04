import 'package:app/page/main_av_page/female_list_page/components/famale_item.dart';
import 'package:app/page/main_av_page/female_list_page/state.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamaleAllList extends StatefulWidget {
  final FemaleListPageState state;
  final Dispatch dispatch;
  FamaleAllList({Key key, this.state, this.dispatch}) : super(key: key);
  @override
  _FamaleAllListState createState() => _FamaleAllListState();
}

var itemRadio = 1.2;
var itemH = s.realW(87) * itemRadio;

class _FamaleAllListState extends State<FamaleAllList> {
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // print(_controller.offset);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _letterHandle(String letter) {
    vibrate();
    var keys = widget.state.famaleListMap.keys.toList();
    double scrollH = 0;
    for (final i in keys) {
      if (i == letter) {
        break;
      }
      scrollH += itemH * (widget.state.famaleListMap[i].length / 4).ceil() +
          s.realH(24);
    }
    _controller.jumpTo(scrollH);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
        controller: _controller,
        padding: EdgeInsets.only(top: 15, right: 15),
        itemBuilder: (context, index) {
          var keys = widget.state.famaleListMap.keys.toList();
          var item = widget.state.famaleListMap[keys[index]];
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        keys[index].toString(),
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  height: s.realH(24),
                  color: Color(0x00f7f7f7),
                ),
                Container(
                  color: Colors.white,
                  height: itemH * (item.length / 4).ceil(),
                  child: GridView.count(
                      padding: EdgeInsets.only(top: 10),
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1 / itemRadio,
                      children: List.generate(item.length, (int i) {
                        return buildfamaleItem(
                            context,
                            widget.state.domain + item[i]['headImg'],
                            item[i]['name'],
                            item[i]['id']);
                      })),
                )
              ],
            ),
          );
        },
        itemCount: widget.state.famaleListMap.keys.toList().length,
      ),
      Positioned(
        right: 0,
        top: 20,
        child: Column(
            children: List.generate(widget.state.letters.length, (int i) {
          return GestureDetector(
            onTap: () => _letterHandle(widget.state.letters[i]),
            child: Container(
              decoration: BoxDecoration(
                  color: widget.state.lettersSelected == i
                      ? Colors.yellow[500]
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Text(
                widget.state.letters[i],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        })),
      )
    ]);
  }
}
