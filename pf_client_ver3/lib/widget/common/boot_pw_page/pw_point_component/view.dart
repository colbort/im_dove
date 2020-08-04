import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'state.dart';
import 'point_view.dart';
import '../action.dart';

Widget buildView(
    PwPointState state, Dispatch dispatch, ViewService viewService) {
  return _BuildView(state: state, dispatch: dispatch);
}

class _BuildView extends StatefulWidget {
  final PwPointState state;
  final Dispatch dispatch;
  _BuildView({this.state, this.dispatch}) : super();
  @override
  __BuildViewState createState() => __BuildViewState(this.state);
}

class __BuildViewState extends State<_BuildView>
    with SingleTickerProviderStateMixin {
  final PwPointState state;

  __BuildViewState(this.state) : super();

  AnimationController controller;
  Animation<double> animation;

  int _flag = 0;
  int _animationFq = 10;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1500));
    animation = Tween(begin: 0.0, end: 10.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: controller))
          ..addListener(() {
            if (mounted) {
              setState(() {
                // Refresh
              });
            }
          })
          ..addStatusListener((AnimationStatus status) {
            if (_flag > _animationFq) {
              widget.dispatch(BootPwActionCreator.onResetPwAction(false));
              _flag = 0;
            }
            if (status == AnimationStatus.completed) {
              controller.reverse().orCancel;
              if (widget.state.isShowAnimate) {
                _flag++;
              }
            } else if (status == AnimationStatus.dismissed) {
              controller.forward().orCancel;
            }
          });
    controller.forward().orCancel;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pwMaxLen = 4;
    List<Widget> ringList = [];
    for (int i = 0; i < pwMaxLen; i++) {
      ringList.add(Padding(
          child: Transform.translate(
              offset:
                  Offset(widget.state.isShowAnimate ? animation.value : 0, 0),
              child: RingWidget(
                ringRadius: 18,
                circleRadius: 18,
                isRingState: (i >= widget.state.typedPwLen),
              )),
          padding: EdgeInsets.all(5)));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ringList,
    );
  }
}
