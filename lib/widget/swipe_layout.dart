import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SwipeLayout extends StatefulWidget {
  final GlobalKey<SwipeLayoutState> key;
  final Widget content;
  final List<Widget> menu;
  final double menuWidth;
  final Mode mode;
  final DragEdge dragEdge;
  final bool enable; //whether can drag
  final VoidCallback onSwipeStarted;
  final VoidCallback onClosed;
  final VoidCallback onOpened;

  @override
  SwipeLayoutState createState() => SwipeLayoutState();

  SwipeLayout(
      {this.key,
      @required this.content,
      this.menu,
      this.menuWidth,
      this.mode = Mode.LayDown,
      this.dragEdge = DragEdge.Right,
      this.enable = true,
      this.onSwipeStarted,
      this.onClosed,
      this.onOpened})
      : assert(enable ? menu != null : true),
        super(key: key);
}

///show mode LayDown content 在menu上方，menu固定不动，PullOut 左右布局方式
enum Mode { LayDown, PullOut }

///drag edge
enum DragEdge {
  Left,
  Right,
}

class SwipeLayoutState extends State<SwipeLayout>
    with SingleTickerProviderStateMixin {
  double translateX = 0.0;
  double maxTranslateX;
  AnimationController _animationController;
//  Map<Type, GestureRecognizerFactory> gestures = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    gestures[HorizontalDragGestureRecognizer] =
//        GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
//      () => HorizontalDragGestureRecognizer(debugOwner: this),
//      (HorizontalDragGestureRecognizer instance) {
//        instance
//          ..onDown = onDragStart
//          ..onUpdate = onDragUpdate
//          ..onEnd = onDragEnd;
//      },
//    );
    maxTranslateX = widget.menuWidth;
    _animationController = new AnimationController(
        duration: Duration(milliseconds: 300),
        lowerBound: -maxTranslateX,
        upperBound: 0.0,
        vsync: this)
      ..addListener(() {
        setState(() {
          translateX = _animationController.value;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) {
      return widget.content;
    } else {
      print("----------maxTranslateX = $maxTranslateX");
      return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            right:
                widget.mode == Mode.LayDown ? 0 : -maxTranslateX - translateX,
            child: Row(children: widget.menu),
          ),
          GestureDetector(
            onHorizontalDragDown: onDragStart,
            onHorizontalDragUpdate: onDragUpdate,
            onHorizontalDragEnd: onDragEnd,
//          RawGestureDetector(
//            gestures: gestures,
            child: Transform.translate(
              offset: Offset(translateX, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: widget.content),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  void close() {
    if (translateX != 0.0) {
      _animationController.animateTo(0.0).then((_) {
        widget.onClosed?.call();
      });
    }
  }

  void open() {
    if (translateX.abs() < maxTranslateX) {
      _animationController.animateTo(-maxTranslateX).then((_) {
        widget.onOpened?.call();
      });
    }
  }

  void onDragStart(DragDownDetails details) {
    widget.onSwipeStarted?.call();
  }

  void onDragUpdate(DragUpdateDetails details) {
    translateX = (translateX + details.delta.dx).clamp(-maxTranslateX, 0.0);
    setState(() {});
  }

  void onDragEnd(DragEndDetails details) {
    _animationController.value = translateX;
    Velocity velocity = details.velocity;
    if (velocity.pixelsPerSecond.dx < -100) {
      //向左滑动
      open();
    } else if (velocity.pixelsPerSecond.dx > 100) {
      //向右滑动
      close();
    } else {
      if (translateX.abs() > widget.menuWidth / 2.0) {
        open();
      } else {
        close();
      }
    }
  }
}
