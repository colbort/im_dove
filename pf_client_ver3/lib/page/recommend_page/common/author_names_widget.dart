import 'package:app/pojo/id_name_bean.dart';
import 'package:app/widget/common/label_widget.dart';
import 'package:flutter/material.dart';

/// 女优名字的组件
class AuthorNamesWidget extends StatelessWidget {
  final List<IdNameBean> authors;
  const AuthorNamesWidget({Key key, this.authors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return authors.length > 0
        ? Container(
            // margin: EdgeInsets.symmetric(horizontal: Dimens.pt6 * 2),
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: authors.map((author) {
                return LabelWidget(author.name, index: author.id);
              }).toList(),
            ),
          )
        : Container();
  }
}
