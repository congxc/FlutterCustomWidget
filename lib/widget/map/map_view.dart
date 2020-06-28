import 'dart:math';
import '../../bean/point_f.dart';
import '../../provider/local_image_provider.dart';
import '../../res/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../gesture/custom_gesture_detector.dart' as gd;
import 'package:vector_math/vector_math_64.dart' as v;
import 'mark_layer.dart';

const bool isDebug = true;

class MapView extends StatefulWidget {
  final double width;
  final double height;
  final String mapImgPath;
  final List<PointF> pointList;
  final ValueChanged<PointF> onPositionSelected;

  const MapView(this.mapImgPath,
      {Key key,
      this.pointList,
      this.width = double.infinity,
      this.height = double.infinity,
      this.onPositionSelected})
      : assert(mapImgPath != null),
        super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  ImageProvider _imageProvider;
  Size _imgSize;
  Offset _offset = Offset.zero;
  Offset _maxOffset = Offset.zero;
  double _minScale; //缩放最小值
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  Matrix4 _transform = Matrix4.identity();

  GlobalKey<MarkLayerState> _markLayerKey;

  MapViewState();

  void _calcMarkLayerTransform(Size imgSize) {
    _scale = _minScale =
        min(widget.height / imgSize.height, widget.width / imgSize.width);
    print("flutter width = " +
        widget.width.toString() +
        ",height = " +
        widget.height.toString() +
        ",imgSize = " +
        imgSize.toString());
    print("flutter scale = " + _scale.toString());
    double translateX =
        (widget.width - _minScale * imgSize.width) / 2.0; //放大之后的X平移值
    double translateY =
        (widget.height - _minScale * imgSize.height) / 2.0; //放大之后的Y平移值
    _offset = _maxOffset = Offset(translateX, translateY);
    _transform = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(_scale, _scale, 1.0);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markLayerKey = new GlobalKey();
    if (isDebug) {
      _imageProvider = AssetImage(Resources.getDrawable("map_0310.png"));
    } else {
      _imageProvider = NativeImageProvider(widget.mapImgPath);
    }
    _imageProvider
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener(
      (ImageInfo info, bool _) {
        double screenScale = MediaQuery.of(context).devicePixelRatio;
        int imgWidth = info.image.width ~/ screenScale;
        int imgHeight = info.image.height ~/ screenScale;
        _imgSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
        _calcMarkLayerTransform(_imgSize);
      },
    ));
  }

  void zoomLarge() {
    setState(() {
      double scale = 1.1 * _scale;
      refreshTransform(scale);
    });
  }

  void zoomSmall() {
    if (_scale <= _minScale) {
      return;
    }
    setState(() {
      double scale = (0.9 * _scale).clamp(_minScale, double.infinity);
      refreshTransform(scale);
    });
  }

  void refreshTransform(double scale) {
    Offset scaleOffset =
        Offset(_imgSize.width, _imgSize.height) * (scale - _scale) / scale;
    _transform
      ..scale(scale / _scale, scale / _scale, 1.0)
      ..translate(-scaleOffset.dx / 2.0, -scaleOffset.dy / 2.0);
    v.Vector3 vector = _transform * v.Vector3(0.0, 0.0, 1.0);
    _offset = Offset(vector.x, vector.y);
    _scale = scale;
  }

  void _handleOnScaleStart(gd.ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
    });
  }

  void _handleOnScaleUpdate(gd.ScaleUpdateDetails details) {
    setState(() {
      if (details.pointCount > 1) {
        _scale =
            (_previousScale * details.scale).clamp(_minScale, double.infinity);
      }
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
      _transform = Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale, _scale, 1.0);
    });
  }

  Offset _clampOffset(Offset offset) {
//    final Size size = context.size; //容器的大小
//    final Offset minOffset =
//        new Offset(size.width, size.height) * (1.0 - _scale);
//    return new Offset(
//        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
    final Offset minOffset = _maxOffset -
        new Offset(_imgSize.width, _imgSize.height) * (_scale - _minScale);
    return new Offset(offset.dx.clamp(minOffset.dx, _maxOffset.dx),
        offset.dy.clamp(minOffset.dy, _maxOffset.dy));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          Container(
            color: AppColors.mapBackgroundColor,
          ),
          buildMapContent(),
          buildController(),
        ],
      ),
    );
  }

  ClipRect buildMapContent() {
    return ClipRect(
      child: gd.GestureDetector(
        onScaleStart: _handleOnScaleStart,
        onScaleUpdate: _handleOnScaleUpdate,
        child: Stack(
          children: <Widget>[
            Transform(
              transform: _transform ?? Matrix4.identity(),
//              transform: Matrix4.identity(),
              child: Image(
                image: _imageProvider,
//                width: widget.width,
//                height: widget.height,
              ),
            ),
            widget.pointList == null
                ? Container()
                : MarkLayer(
                    key: _markLayerKey,
                    pointList: widget.pointList,
                    transform: _transform ?? Matrix4.identity(),
                    onPositionSelected: (point) {
                      _markLayerKey.currentState.setSelectedPosition(point);
                      if (widget.onPositionSelected != null) {
                        widget.onPositionSelected(point);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  /// “+ 、 -”控制放大缩小
  Container buildController() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 92.5),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              zoomLarge();
            },
            child: Image.asset(
                Resources.getDrawable("icon_zoom_large_normal.png")),
          ),
          Padding(
            padding: EdgeInsets.all(7),
          ),
          InkWell(
            onTap: () {
              zoomSmall();
            },
            child: Image.asset(
                Resources.getDrawable("icon_zoom_minify_normal.png")),
          ),
        ],
      ),
    );
  }
}
