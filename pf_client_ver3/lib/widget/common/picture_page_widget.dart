import 'dart:async';
import 'package:app/image_cache/cached_network_image.dart';
import 'package:app/utils/screen.dart';
import 'package:app/utils/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PicturePage extends StatefulWidget {
  final List<String> datas;
  final int index;

  //final ValueChanged onClicked;

  PicturePage({
    @required this.datas,
    @required this.index,
    //  @required this.onClicked,
  });

  @override
  State<StatefulWidget> createState() {
    return _PicturePage();
  }
}

class _PicturePage extends State<PicturePage>
    with SingleTickerProviderStateMixin {
  //var rebuildIndex = StreamController<int>.broadcast();
  var rebuildSwiper = StreamController<bool>.broadcast();
  AnimationController _animationController;
  // Animation<double> _animation;
  Function animationListener;

  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  int currentIndex;
  //bool _showSwiper = true;

  var _controller;

  // double originWidth = 0;
  // bool canScroll = true;
  // SwiperController controller;
  // int index = 0;
  // Timer timer;
  @override
  void initState() {
    currentIndex = widget.index;
    _controller = PageController(
      initialPage: widget.index,
    );
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
    // index = widget.index;

    // controller = SwiperController();
    // controller.addListener(() {
    //   println(index);
    // });
  }

  @override
  void didUpdateWidget(PicturePage oldWidget) {
    // rebuildIndex.close();
    rebuildSwiper.close();
    _animationController?.dispose();
    clearGestureDetailsCache();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // var unIcon = Container(
    //   width: s.realW(6),
    //   height: s.realW(6),
    //   child: Icon(Icons.fiber_manual_record, color: Colors.white),
    // );

    // var icon = Container(
    //   width: s.realW(6),
    //   height: s.realW(6),
    //   child: Icon(Icons.fiber_manual_record, color: Colors.blue),
    // );

    List<Widget> list = ((widget.datas?.length ?? 0) <= 0)
        ? []
        : widget.datas.map((url) {
            // var images = CachedNetworkImage(
            //   cacheManager: ImgCacheMgr(),
            //   imageUrl: getImgDomain() + url,
            //   // width: w,
            //   //height: h,
            //   fit: BoxFit.fitWidth,
            // );
            return ExtendedImage(
              image: CachedNetworkImageProvider(getImgDomain() + url,
                  cacheManager: ImgCacheMgr()),
              fit: BoxFit.fitWidth,
              enableSlideOutPage: true,
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: 1.0,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: true,
                  initialAlignment: InitialAlignment.center,
                );
              },
            );
          }).toList();

    //var i260 = s.realH(260);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ExtendedImageGesturePageView.builder(
          itemBuilder: (BuildContext context, int index) {
            Widget image = GestureDetector(
              child: list[index],
              onTap: () {
                print('点击');
                //slidePagekey.currentState.popPage();
                Navigator.pop(context);
              },
            );

            return image;
          },
          itemCount: widget.datas.length,
          onPageChanged: (int index) {
            setState(() {});
            currentIndex = index;
            // rebuildIndex.add(index);
          },
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
//              //move page only when scale is not more than 1.0
//              canMovePage: (GestureDetails gestureDetails) =>
//                  gestureDetails.totalScale <= 1.0,
          //physics: ClampingScrollPhysics(),
        ),
        Positioned(
            bottom: 10.0,
            child: Container(
              width: s.realW(50),
              height: s.realH(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0x55000000),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                '${currentIndex + 1}/${widget.datas.length}',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ))
      ],
    );
    // return Container(
    //   // alignment: Alignment.topCenter,
    //   height: double.infinity,
    //   child: Swiper(
    //     outer: false,
    //     index: index,
    //     // controller: controller,
    //     itemBuilder: (BuildContext context, int current) {
    //       index = current;
    //       print('index$index');
    //       if (list.length > index) return list[index];

    //       return Container();
    //     },
    //     physics: canScroll
    //         ? (widget.datas.length == 1
    //             ? NeverScrollableScrollPhysics()
    //             : ClampingScrollPhysics())
    //         : NeverScrollableScrollPhysics(),
    //     layout: SwiperLayout.DEFAULT,
    //     itemCount: widget.datas?.length ?? 0,
    //     pagination: widget.datas.length == 1
    //         ? null
    //         : SwiperPagination(
    //             alignment: Alignment.bottomCenter,
    //             margin: EdgeInsets.only(bottom: i25, right: 10),
    //             builder:
    //                 SwiperBuilder(activeW: icon, normalW: unIcon, space: 10.0)),

    //     autoplay: false,
    //   ),
    // );
  }
}

// Widget DotsIndicator(int index, int length) {
//   Widget _buildDot(int i) {
//     return Container(
//       padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
//       width: s.realW(3),
//       height: s.realH(3),
//       child: Icon(Icons.fiber_manual_record,
//           color: i == index ? Colors.blue : Colors.white),
//     );
//   }

//   return Container(
//     decoration: BoxDecoration(
//       color: Color(0x55ffffff),
//     ),
//     child: Text('$index/$length'),
//   );
// }
