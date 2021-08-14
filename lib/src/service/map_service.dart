import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/utils/image_to_bytes.dart';
import 'package:getx_map/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  late GoogleMapController controller;
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polyLines = {};
  final Map<PolygonId, Polygon> _polygons = {};

  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polyLines.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-0.2053476, -78.4894387),
    zoom: 15,
  );

  final topPadding = Get.mediaQuery.size.height * 0.25;

  void init(GoogleMapController controller) async {
    controller.setMapStyle(mapStyle);
    this.controller = controller;
  }

  Future<Position> getCurrentPostion() async {
    Position current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return current;
  }

  Future<BitmapDescriptor> generateIcon(String path) async {
    final _iconMaker = Completer<BitmapDescriptor>();

    final bytes = await imageToBytes(path, width: 60);
    final bitmap = BitmapDescriptor.fromBytes(bytes);
    _iconMaker.complete(bitmap);
    return _iconMaker.future;
  }

  Future<void> updateCamera(Position position, double zoom) async {
    final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), zoom);

    controller.animateCamera(cameraUpdate);
  }

  void addPolygon(LatLng position) {
    final id = "0";
    final polygonId = PolygonId(id);
    Polygon polygon;
    if (_polygons.containsKey(polygonId)) {
      final temp = _polygons[polygonId]!;
      polygon = temp.copyWith(pointsParam: [...temp.points, position]);
    } else {
      final color = Colors.primaries[polylines.length];
      polygon = Polygon(
          polygonId: polygonId,
          points: [position],
          strokeWidth: 4,
          strokeColor: color,
          fillColor: color.withOpacity(0.4));
    }
    _polygons[polygonId] = polygon;
  }

  void addPolyLine(LatLng position) {
    final id = "0";
    final polylineId = PolylineId(id);
    Polyline polyline;
    if (_polyLines.containsKey(polylineId)) {
      final temp = _polyLines[polylineId]!;
      polyline = temp.copyWith(pointsParam: [...temp.points, position]);
    } else {
      // final color = Colors.primaries[polylines.length];
      polyline = Polyline(
          polylineId: polylineId,
          points: [position],
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap);
    }
    _polyLines[polylineId] = polyline;
    print(_polyLines.length);
  }

  void addMarker(LatLng position, {BitmapDescriptor? icon}) {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
      icon: icon ?? BitmapDescriptor.defaultMarker,
      rotation: 22.0,
      onTap: () {
        print("Tap marker");
      },
      onDragEnd: (newPosition) {
        print("new position $newPosition");
      },
    );

    _markers[markerId] = marker;
  }
}
