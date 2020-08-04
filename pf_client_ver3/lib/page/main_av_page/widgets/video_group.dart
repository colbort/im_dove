import 'package:app/config/colors.dart';
import 'package:app/lang/lang.dart';
import 'package:app/page/main_av_page/widgets/vedio_item.dart';
import 'package:app/pojo/av_data.dart';
import 'package:app/utils/dimens.dart';
import 'package:app/widget/update_animate.dart';
import 'package:flutter/cupertino.dart';

typedef Next = void Function(VideoGroupBean);

class VideoGroup extends StatefulWidget {
  final VideoGroupBean data;
  final NextController controller;
  final Next onNext;
  VideoGroup({
    this.data,
    this.controller,
    this.onNext,
  });
  @override
  _VideoGroupState createState() => _VideoGroupState();
}

class _VideoGroupState extends State<VideoGroup> {
  UpdateContorller _contorller;
  VideoGroupBean _data;
  var itemw;
  var itemh;

  void _next(VideoGroupBean data) {
    _contorller.stop();
    if (data == null || (data?.videos?.length ?? 0) <= 0) return;
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    itemw = (Dimens.pt360 - 40) / 2;
    itemh = itemw * 2 / 3;
    _contorller = UpdateContorller();
    _data = widget.data;
    widget.controller?.next = _next;
  }

  @override
  Widget build(BuildContext context) {
    return ((_data?.videos?.length ?? 0) > 0)
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _data.topicName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: c.c333333,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
                            UpdateAnimate(
                              updateContorller: _contorller,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Text(
                              Lang.AV_ANOTHER_BATCH,
                              style: TextStyle(
                                fontSize: 16,
                                color: c.c9E9E9E,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (_contorller.start != null) {
                            _contorller.start();
                          }
                          widget.onNext(_data);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 3 * (itemh + 26) + 30,
                  child: GridView.builder(
                    itemCount: _data?.videos?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      return VideoPreview(
                        width: itemw,
                        height: itemh,
                        data: _data.videos[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

class NextValue {
  const NextValue({this.next});

  NextValue copyWith({
    Next next,
  }) {
    return NextValue(
      next: next,
    );
  }

  final Next next;
}

class NextController extends ValueNotifier<NextValue> {
  NextController({Next next}) : super(NextValue(next: next));

  Next get next => value.next;
  set next(Next next) => value = value.copyWith(next: next);
}
