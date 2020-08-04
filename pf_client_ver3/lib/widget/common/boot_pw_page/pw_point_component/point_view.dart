import 'package:flutter/material.dart';

class RingWidget extends StatefulWidget {
  final double ringRadius;
  final bool isRingState;
  final double circleRadius;

  RingWidget({
    Key key,
    @required this.ringRadius,
    @required this.isRingState,
    @required this.circleRadius,
  })  : assert(ringRadius > 0 && circleRadius > 0),
        super(key: key);

  @override
  _RingWidgetState createState() => _RingWidgetState();
}

class _RingWidgetState extends State<RingWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration: !widget.isRingState
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: Offset(0, 4), //阴影xy轴偏移量
                        blurRadius: 6, //阴影模糊程度
                        spreadRadius: 0 //阴影扩散程度
                        )
                  ])
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Color(0xff979797), width: 1)),
        child: Center(
            child: !widget.isRingState
                ? Image(
                    image: AssetImage('assets/boot_pw/cicle.png'),
                    width: widget.ringRadius,
                    height: widget.ringRadius,
                  )
                : null
            // Image(
            //     image: AssetImage('assets/boot_pw/ring.png'),
            //     width: widget.circleRadius,
            //     height: widget.circleRadius,
            //   )
            ));
  }
}
