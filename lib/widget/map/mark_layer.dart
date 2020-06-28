import "../../bean/point_f.dart";
import '../../res/style/style.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class MarkLayer extends StatefulWidget {
  final Matrix4 transform; //偏移量
  final List<PointF> pointList;
  final ValueChanged<PointF> onPositionSelected;

  const MarkLayer(
      {Key key,
      @required this.pointList,
      this.transform,
      this.onPositionSelected})
      : assert(transform != null),
        assert(pointList != null),
        super(key: key);

  @override
  MarkLayerState createState() => MarkLayerState();
}

class MarkLayerState extends State<MarkLayer> {
  PointF _selectedPosition;
  final double _leftOffset = 9;
  final double _topOffset = 12;

  void setSelectedPosition(PointF value) {
    if (_selectedPosition == value) {
      return;
    }
    _selectedPosition = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: positionWidgets(),
      ),
    );
  }

  List<Widget> positionWidgets() {
    Image selectedImg = Image.asset(
      Resources.getDrawable("icon_map_location_selected.png"),
      width: 18,
      height: 18,
    );
    Image normalImg = Image.asset(
      Resources.getDrawable("icon_map_location_normal.png"),
      width: 18,
      height: 18,
    );
    List<Widget> positions = [];
    int index = -1;
    final length = widget.pointList.length;
    for (PointF point in widget.pointList) {
      index++;
      v.Vector3 vector = widget.transform * v.Vector3(point.dx, point.dy, 0.0);
      v.Vector3 vector = v.Vector3(point.dx, point.dy, 0.0);
      bool isSelected = point == _selectedPosition;
      Widget item = Positioned(
        left: vector.x - _leftOffset,
        top: vector.y - _topOffset,
        child: InkWell(
          onTap: () {
            if (widget.onPositionSelected != null) {
              widget.onPositionSelected(point);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isSelected ? selectedImg : normalImg,
              Padding(padding: EdgeInsets.only(left: 6)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.selectedMarkTagBgColor
                      : AppColors.normalMarkTagBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: Text(
                  point.pointName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      positions.add(item);
    }
    return positions;
  }
}
