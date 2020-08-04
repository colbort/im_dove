import 'package:app/lang/lang.dart';
import 'package:app/page/search_page/paoba_component/pao_friend_list_widget.dart';
import 'package:app/utils/screen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'state.dart';

Widget buildView(PaoBaState state, Dispatch dispatch, ViewService viewService) {
  return
      // color: Colors.black12,
      SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //炮友
        state.userList.length == 0
            ? Container()
            : paoFriendList(state, dispatch),
        Container(
          margin: EdgeInsets.only(left: s.realW(16), top: s.realH(10)),
          width: s.realW(44),
          child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  child: Container(
                    height: s.realH(10),
                    width: s.realW(44),
                    decoration: BoxDecoration(
                        color: Color(0xffFFE300),
                        borderRadius: BorderRadius.circular(25.0)),
                  )),
              Center(
                child: Text(
                  Lang.HUATI,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        state.dataList.length == 0
            ? SizedBox(
                height: s.realH(100),
              )
            : viewService.buildComponent('paobaList'),
        //话题
        // SliverToBoxAdapter(
        //   child: viewService.buildComponent('paobaList'),
        // )
      ],
    ),
  );
}
