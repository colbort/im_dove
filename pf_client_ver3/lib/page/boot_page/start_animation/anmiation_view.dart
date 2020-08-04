import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/screen.dart';
import 'package:flutter_svg/svg.dart';

EventBus bootAniBus;

class ScaleAnimationRoute extends StatefulWidget {
  @override
  _ScaleAnimationRouteState createState() => _ScaleAnimationRouteState();
}

class _ScaleAnimationRouteState extends State<ScaleAnimationRoute>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> iconPSTAnimation;
  Animation<double> iconSIZEAnimation;
  Animation<double> titlePSTAnimation;
  Animation<double> titleOPAAnimation;

  AnimationController controller;

  bool isForward = false;
  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    //透明度
    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    // 图标位置
    iconPSTAnimation = Tween(begin: 1.0, end: 0.65).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    //图标尺寸
    iconSIZEAnimation = Tween(begin: 1.0, end: 0.4).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    //文字位置
    titlePSTAnimation = Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
    //文字透明度
    titleOPAAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    bootAniBus = EventBus();
    bootAniBus.on().listen((event) async {
      Future.delayed(Duration(seconds: 1), () {
        controller.forward();
      });
    });

    //动画结束状态
    animation.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        //
      } else if (state == AnimationStatus.dismissed) {
        //
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: Image(
        image: AssetImage(
          'assets/main/puffApp.png',
        ),
      ),
      builder: (BuildContext ctx, Widget child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.red,
                  child: SvgPicture.asset(
                    "assets/mine/placeholderImage.svg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                // top: 100,
                // left: 100,
                child: AnimatedOpacity(
                    opacity: animation.value,
                    duration: Duration(milliseconds: 50),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                top: s.realW(150),
                left: s.realW(140) * titlePSTAnimation.value,
                child: AnimatedOpacity(
                    opacity: titleOPAAnimation.value,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                        width: s.realW(150),
                        height: s.realW(100),
                        child: Image(
                          image: AssetImage(
                            'assets/mine/puffApp.png',
                          ),
                        ))),
              ),
              Positioned(
                top: s.realW(260) * iconPSTAnimation.value,
                left: s.realW(100) * iconPSTAnimation.value,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: s.realW(150) * iconSIZEAnimation.value,
                      height: s.realW(150) * iconSIZEAnimation.value,
                      color: Colors.white,
                      child: SvgPicture.asset('assets/mine/iconBig.svg'),
                    )),
              ),
              Positioned(
                bottom: s.realW(50),
                left: s.realW(75),
                child: Container(
                    width: s.realW(220),
                    height: s.realW(100),
                    child: Image(
                      image: AssetImage(
                        'assets/mine/addColour.png',
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    bootAniBus.destroy();
    bootAniBus = null;
    super.dispose();
  }
}
