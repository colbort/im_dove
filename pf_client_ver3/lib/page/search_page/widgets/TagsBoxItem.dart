import 'package:app/storage/shared_pre_util.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_svg/svg.dart';

import '../action.dart';

class TagsBoxItem extends StatelessWidget {
  final String itemTitle;
  final List<String> tagsBox;
  final bool showDelIcon;
  final Dispatch dispatch;
  final int type; //1av 2泡吧
  final TextEditingController searchController;
  TagsBoxItem(
      {Key key,
      this.dispatch,
      this.itemTitle,
      this.tagsBox,
      this.searchController,
      this.showDelIcon = false,
      this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 15, top: 20, bottom: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  itemTitle,
                  style: TextStyle(fontSize: 16),
                ),
                showDelIcon
                    ? IconButton(
                        icon: SvgPicture.asset('assets/common/delete.svg'),
                        onPressed: () {
                          //删除所有记录
                          sharedPre.deleteAllHistoryTags();
                          dispatch(MainSearchActionCreator.saveHistoryTags([]));
                        },
                      )
                    : SizedBox.shrink()
              ],
            ),
            Container(
              child: tagsBox.length > 0
                  ? Wrap(
                      spacing: 8.0, // 主轴(水平)方向间距
                      runSpacing: 10.0, // 纵轴（垂直）方向间距
                      children: tagsBox
                          .map((f) => buildTagItem(
                              dispatch, f, searchController, showDelIcon, type))
                          .toList(),
                    )
                  : SizedBox.shrink(),
              margin: EdgeInsets.only(top: 20.0),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildTagItem(Dispatch dispatch, String text,
    TextEditingController searchController, bool delete, int type) {
  var color = getFlagColors(text);

  return GestureDetector(
    onTap: () {
      searchController.text = text;

      if (type == 2) dispatch(MainSearchActionCreator.onSearchUserData());
      dispatch(MainSearchActionCreator.onSearchData(searchController.text));
    },
    child: Container(
      //alignment: Alignment.center,
      //height: s.realH(20),
      height: s.realH(25),
      decoration: BoxDecoration(
          // color: Color(0x1a363636),
          color: delete ? Color(0x1aA5A5A5) : color['b'],
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, delete ? 10 : 15, 0),
        child: delete
            ? SizedBox(
                // width: s.realW(50),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 100,
                      ),
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: delete ? Color(0xff333333) : color['t'],
                            fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sharedPre.deleteSingleHistoryTag(text).then((list) {
                          dispatch(
                              MainSearchActionCreator.saveHistoryTags(list));
                        });
                      },
                      child: Container(
                          margin: EdgeInsetsDirectional.only(start: s.realW(5)),
                          padding: EdgeInsets.all(5),
                          width: s.realW(20),
                          height: s.realH(20),
                          child:
                              SvgPicture.asset('assets/common/delete_tag.svg')),
                    ),
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: 50,
                ),
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: delete ? Color(0xff333333) : color['t'],
                      fontSize: 14),
                ),
              ),
      ),
    ),
  );
}
