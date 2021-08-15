import 'package:flexible_polyline/flexible_polyline.dart';
import 'package:getx_map/src/utils/distance_format.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HereRoute {
  final int duration, length;
  final List<LatLng> points;

  String get distanceString {
    return distanceFormat(length);
  }

  HereRoute({
    required this.duration,
    required this.length,
    required this.points,
  });

  factory HereRoute.fromJson(Map<String, dynamic> map) {
    final json = map["sections"][0];

    final duration = json['summary']['duration'] as int;
    final length = json['summary']['length'] as int;

    final polyline = json['polyline'] as String;
    final points = FlexiblePolyline.decode(polyline)
        .map((e) => LatLng(e.lat, e.lng))
        .toList();

    return HereRoute(
      duration: duration,
      length: length,
      points: points,
    );
  }
}
