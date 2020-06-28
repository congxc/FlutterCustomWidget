// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_f.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointF _$PointFFromJson(Map<String, dynamic> json) {
  return PointF(
    (json['x'] as num).toDouble(),
    (json['y'] as num).toDouble(),
    json['pointId'] as String,
    json['pointName'] as String,
  );
}

Map<String, dynamic> _$PointFToJson(PointF instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'pointId': instance.pointId,
      'pointName': instance.pointName,
    };
