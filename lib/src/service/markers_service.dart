import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:getx_map/src/utils/marker_generator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class MarkersSearvice extends GetxService {
  static MarkersSearvice get to => Get.find();

  List<BitmapDescriptor> userIcons = [];
  late BitmapDescriptor stationIcon;
  late BitmapDescriptor restaurnatIcon;
  final generator = MarkerGenerator(20.h);

  @override
  void onInit() async {
    super.onInit();
    await generateUserIcons();
    await generateStationIcon();
    await generateRestaurantIcon();
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
      CommonIcon.stationIcon,
      Colors.black,
      Colors.black,
      Colors.transparent,
    );
  }

  Future<void> generateRestaurantIcon() async {
    restaurnatIcon = await generator.createBitmapDescriptorFromIconData(
      Icons.dinner_dining_outlined,
      ColorsConsts.favoritebadgeColor,
      ColorsConsts.favoritebadgeColor,
      Colors.transparent,
    );
  }
}
