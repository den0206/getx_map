import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/model/station.dart';

class RouteUser {
  final Icon icon;
  final BitmapDescriptor mapIcon;
  Station? station;

  RouteUser({
    required this.icon,
    required this.mapIcon,
    this.station,
  });
}
