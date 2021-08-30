import 'package:flutter/material.dart';
import 'package:getx_map/src/utils/consts_color.dart';

class CommonIcon {
  static final IconData stationIcon = Icons.directions_transit;

  static Icon getPersonIcon(int index) {
    return Icon(
      Icons.person,
      color: ColorsConsts.iconColors[index],
    );
  }
}
