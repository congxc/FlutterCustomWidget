import 'package:json_annotation/json_annotation.dart';
part 'point_f.g.dart';
/// 描述地图上的位置点坐标
@JsonSerializable(nullable: false)
class PointF {
  final double x;
  final double y;
  final String pointId;
  final String pointName;

  PointF(this.x, this.y, this.pointId, this.pointName);

  factory PointF.fromJson(Map<String, dynamic> json) => _$PointFFromJson(json);
  Map<String, dynamic> toJson() => _$PointFToJson(this);

  String get name => pointName;

  String get id => pointId;

  double get dy => y;

  double get dx => x;

  @override
  String toString() {
    return 'PointF{x: $x, y: $y, pointId: $pointId, pointName: $pointName}';
  }
}
