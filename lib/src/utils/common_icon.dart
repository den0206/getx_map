import 'package:flutter/material.dart';
import 'package:getx_map/src/utils/consts_color.dart';

class CommonIcon {
  static final IconData stationIcon = Icons.directions_transit;

  static Icon getPersonIcon(int index, {double? size}) {
    return Icon(
      Icons.person,
      size: size,
      color: ColorsConsts.iconColors[index],
    );
  }
}
