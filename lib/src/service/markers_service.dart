import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:getx_map/src/utils/marker_generator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersSearvice extends GetxService {
  static MarkersSearvice get to => Get.find();

  List<BitmapDescriptor> userIcons = [];
  late BitmapDescriptor stationIcon;
  final generator = MarkerGenerator(200);

  @override
  void onInit() async {
    super.onInit();
    await generateUserIcons();
    await generateStationIcon();
    print("Generate Icons");
  }

  Future<void> generateUserIcons() async {
    await Future.forEach(ColorsConsts.iconColors, (Color color) async {
      final iconMarker = await generator.createBitmapDescriptorFromIconData(
          Icons.person, color, color, Colors.transparent);

      userIcons.add(iconMarker);
    });
  }

  Future<void> generateStationIcon() async {
    stationIcon = await generator.createBitmapDescriptorFromIconData(
      Icons.directions_transit,
      Colors.black,
      Colors.black,
      Colors.transparent,
    );
  }
}
