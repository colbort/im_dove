part of '../core/toast.dart';

class _ToastContainer extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final bool movingOnWindowChange;
  final ToastPosition position;

  const _ToastContainer({
    Key key,
    this.duration,
    this.child,
    this.movingOnWindowChange = false,
    this.position,
  }) : super(key: key);

  @override
  __ToastContainerState createState() => __ToastContainerState();
}

class __ToastContainerState extends State<_ToastContainer>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  double opacity = 0.0;
  AnimationController controller;
  CurvedAnimation curve;
  Animation<Offset> animation;

  bool get movingOnWindowChange => widget.movingOnWindowChange;

  double get offset => widget.position.offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: _opacityDuration, vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.1),
    ).animate(curve);
    Future.delayed(const Duration(milliseconds: 30), () {
      if (!mounted) {
        return;
      }
      setState(() {
        opacity = 1.0;
        controller.forward().orCancel;
      });
    });

    Future.delayed(widget.duration - _opacityDuration, () {
      if (!mounted) {
        return;
      }
      setState(() {
        opacity = 0.0;
        controller.reverse().orCancel;
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (this.mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget w = SlideTransition(
      position: animation,
      child: AnimatedOpacity(
        duration: _opacityDuration,
        child: widget.child,
        opacity: opacity,
      ),
    );
    if (movingOnWindowChange != true) {
      return w;
    }
    final mediaQueryData = MediaQueryData.fromWindow(ui.window);
    Widget container = w;
    final edgeInsets =
        EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom);
    if (offset > 0) {
      container = AnimatedPadding(
        duration: _opacityDuration,
        padding: EdgeInsets.only(top: offset) + edgeInsets,
        child: container,
      );
    } else if (offset < 0) {
      container = AnimatedPadding(
        duration: _opacityDuration,
        padding: EdgeInsets.only(bottom: offset.abs()) + edgeInsets,
        child: container,
      );
    } else {
      container = AnimatedPadding(
        duration: _opacityDuration,
        padding: edgeInsets,
        child: container,
      );
    }
    return container;
  }

  void showDismissAnim() {
    setState(() {
      opacity = 0.0;
      controller.reverse().orCancel;
    });
  }
}
