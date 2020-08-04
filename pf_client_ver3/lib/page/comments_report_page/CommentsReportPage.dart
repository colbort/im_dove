import 'package:app/utils/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentsReportPage extends StatefulWidget {
  CommentsReportPage({Key key}) : super(key: key);

  @override
  _CommentsReportPageState createState() => _CommentsReportPageState();
}

class _CommentsReportPageState extends State<CommentsReportPage> {
  final double iw = s.realW(360);

  int selectedIndex = 0;
  var reportSucess = false;
  final backColor = Color.fromRGBO(245, 245, 245, 1.0);
  final items = ["违法违规", "谩骂，人身攻击", "垃圾广告", "政治敏感", "造谣传谣", "骚扰"];
  void selectFunction(String title) {
    int index = items.indexWhere((f) => f == title);
    setState(() {
      selectedIndex = index;
    });
  }

  //MARK:--举报接口
  void reportAction() async {
    setState(() {
      reportSucess = !reportSucess;
    });
  }

  void positiveAction() {
    Navigator.pop(this.context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                color: Colors.black,
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                // tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              );
            },
          ),
          backgroundColor: backColor,
          title: Container(
            width: iw,
            child: Text(
              '评论举报',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 20, height: 28 / 20, color: Colors.black),
            ),
          ),
        ),
        backgroundColor: backColor,
        body: reportSucess
            ? buildSucessView()
            : Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: backColor,
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "请选择举报分类",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(107, 107, 107, 1.0)),
                        ),
                      ),
                      Container(
                        height: 40.0 * items.length,
                        color: Colors.white,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (ctx, index) {
                            return buildCell(items[index],
                                index == selectedIndex, selectFunction);
                          },
                          itemCount: items.length,
                          itemExtent: 40,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                    left: 30,
                    right: 30,
                    height: 38,
                    child: buildBottomButton("举报", reportAction),
                  )
                ],
              ));
  }

  //MARK:--举报成功
  Widget buildSucessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 134),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: backColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Color(0xff999797), width: 1.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                (MediaQuery.of(this.context).size.width - 200) / 2.0,
                20,
                (MediaQuery.of(this.context).size.width - 200) / 2.0,
                0),
            child: Text(
              "举报提交成功，我们将在24小时内进行处理。",
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: buildBottomButton("确定", positiveAction),
          ),
        ],
      ),
    );
  }

  //MARK:--单个cell
  Widget buildCell(String title, bool selected, Function selectFunction) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(),
            ),
            Positioned.fill(
              top: 10,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              right: 15.0,
              top: 15,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: selected ? Color(0xff979797) : Color(0xffD8D8D8),
                    width: 1.0,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          height: 6.0,
                          width: 6.0,
                          decoration: BoxDecoration(
                            color: Color(0XFFFFFA00),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        selectFunction(title);
      },
    );
  }

  //MARK:--举报按钮
  Widget buildBottomButton(String title, Function reportAction) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        height: 38,
        width: 354,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19.0),
          color: Color.fromRGBO(253, 225, 57, 1),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
      onTap: () {
        reportAction();
      },
    );
  }
}
