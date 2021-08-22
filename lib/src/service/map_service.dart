import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/utils/consts_color.dart';
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
    target: LatLng(35.6875, 139.703056),
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

    updateCamera(LatLng(current.latitude, current.longitude));
    return current;
  }

  Future<BitmapDescriptor> generateIcon(String path) async {
    final _iconMaker = Completer<BitmapDescriptor>();

    final bytes = await imageToBytes(path, width: 60);
    final bitmap = BitmapDescriptor.fromBytes(bytes);
    _iconMaker.complete(bitmap);
    return _iconMaker.future;
  }

  Future<void> updateCamera(LatLng latLng, {double? setZoom}) async {
    final zoom = await controller.getZoomLevel();

    final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(latLng.latitude, latLng.longitude), setZoom ?? zoom);

    controller.animateCamera(cameraUpdate);
  }

  void showInfoService(String id) {
    controller.showMarkerInfoWindow(MarkerId(id));
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

  Future fitMarkerBounds() async {
    final zoomBounds = getMarkersBounds(markers.toList());
    await controller
        .animateCamera((CameraUpdate.newLatLngBounds(zoomBounds, 70)));
  }

  Future<void> presentRout(
      Place origin, Place destination, List<LatLng> points) async {
    resetMap();

    /// add polyline
    addPolyLine(points);

    /// zoom
    final zoomBounds = getCameraZoom(origin.position, destination.position);
    await controller
        .animateCamera(CameraUpdate.newLatLngBounds(zoomBounds, 70));

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
  void resetMap() {
    _markers.clear();
    _polyLines.clear();
    _polygons.clear();
    _circles.clear();
  }

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

  LatLngBounds getMarkersBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

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
      infoWindow: InfoWindow(
        title: place.title,
        snippet: snippet,
      ),
    );

    _markers[markerId] = marker;
  }

  void addStationMarker(Station station,
      {BitmapDescriptor? icon, Function()? onTap}) {
    final markerId = MarkerId(station.id);
    final marker = Marker(
      markerId: markerId,
      position: station.latLng,
      draggable: true,
      icon: icon ?? BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: station.name,
      ),
      onTap: onTap,
    );

    _markers[markerId] = marker;
  }

  void removeStationMarker(Station station) {
    final markerId = MarkerId(station.id);

    _markers.remove(markerId);
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
  }

  Future<LatLng> getCenter() async {
    LatLngBounds visibleRegion = await controller.getVisibleRegion();

    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  void addCenterMarker(LatLng latLng) {
    final markerId = MarkerId("center");
    final marker = Marker(
      markerId: markerId,
      position: latLng,
      draggable: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
        title: "center",
        snippet: "center",
      ),
    );

    final circleId = CircleId("center");
    final circle = Circle(
      circleId: circleId,
      strokeColor: Colors.grey,
      strokeWidth: 3,
      radius: 1000,
      center: latLng,
      fillColor: ColorsConsts.themeYellow.withOpacity(0.5),
    );

    _markers[markerId] = marker;

    _circles[circleId] = circle;
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