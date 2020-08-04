import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:date_format/date_format.dart';
import 'state.dart';

// Widget _splitLine() {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 2),
//     child: Container(
//       height: 1,
//       color: Colors.grey,
//     ),
//   );
// }

Widget buildView(
    NoticeItemState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                'assets/notice/notice.svg',
                width: 40,
                height: 40,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    state.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      formatDate(DateTime.parse(state.createdAt),
                          [yyyy, '-', mm, '-', dd]),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Text(state.content,
                      style: TextStyle(
                        fontSize: 14,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
