import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:getx_map/src/utils/image_to_bytes.dart';
import 'package:getx_map/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  late GoogleMapController controller;
  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polyLines = {};
  final Map<PolygonId, Polygon> _polygons = {};
  final Map<CircleId, Circle> _circles = {};

  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polyLines.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();
  Set<Circle> get circles => _circles.values.toSet();

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-0.2053476, -78.4894387),
    zoom: 15,
  );

  final topPadding = Get.mediaQuery.size.height * 0.1;

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

  void presentRout(Place origin, Place destination, List<LatLng> points) {
    /// add polyline
    addPolyLine(points);

    /// zoom
    final zoomBounds = getCameraZoom(origin.position, destination.position);
    controller.animateCamera(CameraUpdate.newLatLngBounds(zoomBounds, 70));

    /// add Marke
    addMarker(
      origin,
      snippet: "origin",
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    addCircle(origin);

    addMarker(
      destination,
      snippet: "destination",
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    addCircle(destination);
  }
}

extension MapServiceEXT on MapService {
  LatLngBounds getCameraZoom(LatLng origin, LatLng destination) {
    LatLngBounds bounds;

    if (origin.latitude > destination.latitude &&
        origin.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: origin);
    } else if (origin.longitude > destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(origin.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, origin.longitude),
      );
    } else if (origin.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, origin.longitude),
        northeast: LatLng(origin.latitude, destination.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: origin, northeast: destination);
    }

    return bounds;
  }

  void addPolyLine(List<LatLng> points) {
    final id = "polyid";
    final polylineId = PolylineId(id);
    Polyline polyline;

    // final color = Colors.primaries[polylines.length];
    polyline = Polyline(
      polylineId: polylineId,
      color: Color.fromARGB(255, 95, 109, 237),
      points: points,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    _polyLines[polylineId] = polyline;
    print(_polyLines.length);
  }

  void addMarker(Place place, {String? snippet, BitmapDescriptor? icon}) {
    final markerId = MarkerId(place.id);
    final marker = Marker(
      markerId: markerId,
      position: place.position,
      draggable: true,
      icon: icon ?? BitmapDescriptor.defaultMarker,
      rotation: 22.0,
      infoWindow: InfoWindow(
        title: place.title,
        snippet: snippet,
      ),
    );

    _markers[markerId] = marker;
  }

  void addCircle(Place place) {
    final circleId = CircleId(place.id);
    final circle = Circle(
      circleId: circleId,
      strokeColor: Colors.red,
      strokeWidth: 3,
      radius: 12,
      center: place.position,
      fillColor: Color(0xFF21ba45),
    );

    _circles[circleId] = circle;
  }

  Future<void> setZoom(bool zoomIn) async {
    double zoom = await controller.getZoomLevel();

    if (!zoomIn) {
      if (zoom - 1 <= 0) {
        return;
      }
    }

    zoom = zoomIn ? zoom + 1 : zoom - 1;
    final bounds = await controller.getVisibleRegion();
    final northeast = bounds.northeast;
    final southwest = bounds.southwest;
    final center = LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );
    final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
    await controller.animateCamera(cameraUpdate);
    print("COMPLETE");
  }
}



  // Future<List<LatLng>> getPolylinePoints(
  //     LatLng originLat, LatLng destLat) async {
  //   final String key = FlutterConfig.get('GOOGLE_DIRECTION_KEY');
  //   print(key);
  //   List<LatLng> polylineCoordinates = [];

  //   PolylinePoints polylinePoints = PolylinePoints();

  //   final a = PointLatLng(originLat.latitude, originLat.longitude);
  //   final b = PointLatLng(destLat.latitude, destLat.longitude);

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     key,
  //     a,
  //     b,
  //     travelMode: TravelMode.driving,
  //   );

  //   print(result.points);

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   return polylineCoordinates;
  // }