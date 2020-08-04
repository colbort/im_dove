import 'package:app/lang/lang.dart';
import 'package:app/page/search_page/action.dart';
import 'package:app/storage/shared_pre_util.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final double i10 = s.realH(10);
final double leftMargin = 2.0 + 40.0;
final double rightMargin = i10 + 40.0 + 16.0;

Widget buildSearchTextField(
    BuildContext context,
    TextEditingController controller,
    Dispatch dispatch,
    Function clean,
    Function search) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 30, maxWidth: s.realW(231)),
    child: Container(
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88F5F5F5),
              spreadRadius: 2.0,
            ),
          ]),
      child: TextField(
        cursorColor: Color(0xff000000),
        style: TextStyle(color: Color(0xff000000), fontSize: 13),
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 15),
          hintText: Lang.INPUT_SEARCH,
          hintStyle: TextStyle(color: Color(0xff979797), fontSize: 13),
          suffixIcon: Container(
            margin: EdgeInsets.only(right: 10),
            width: s.realW(55),
            child: Row(
              children: <Widget>[
                controller.text.length != 0
                    ? GestureDetector(
                        onTap: () {
                          controller.clear();
                          clean();
                        },
                        child: Container(
                            width: s.realW(24),
                            height: s.realH(24),
                            margin: EdgeInsets.only(right: s.realW(5)),
                            padding: EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              'assets/common/clean.svg',
                            )),
                      )
                    : SizedBox(width: s.realW(29)),
                GestureDetector(
                  onTap: () {
                    if (controller.text != '' && controller.text != null) {
                      //隐藏键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                      sharedPre.saveHistoryTag(controller.text).then((list) {
                        dispatch(MainSearchActionCreator.saveHistoryTags(list));
                        search();
                      });
                    }
                  },
                  child: Container(
                    width: s.realW(24),
                    height: s.realH(24),
                    padding: EdgeInsets.all(2),
                    //  color: Colors.black,
                    child: SvgPicture.asset('assets/common/searchWhite.svg',
                        color: Color(0xff000000)),
                  ),
                )
              ],
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xffffffff),
        ),
        onChanged: (v) {
          dispatch(MainSearchActionCreator.updateSearch(v));
        },
        onTap: () {
          //  search();
        },
        focusNode: focusNode,
      ),
    ),
  );
}

final FocusNode focusNode = FocusNode();

class SearchBar extends StatelessWidget {
  final Dispatch dispatch;
  final TextEditingController searchController;
  final Function clean;
  final Function search;

  SearchBar(this.dispatch, this.searchController, this.clean, this.search,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: s.realH(45),
        child: Padding(
          padding: EdgeInsets.only(left: 2, right: 16),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  searchController.clear();
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.navigate_before,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              Expanded(
                  child: buildSearchTextField(
                      context, searchController, dispatch, clean, search)),
            ],
          ),
        ));
  }
}
