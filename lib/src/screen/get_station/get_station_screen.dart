import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_map/src/screen/get_station/get_station_controller.dart';
import 'package:getx_map/src/screen/get_station/search_station_abstract/search_abstract.dart';

class GetStationScreen extends GetView<GetStationController> {
  const GetStationScreen({Key? key}) : super(key: key);

  static const routeName = '/GetStation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AbstractSearchScreen(
        controller: controller,
        onSelect: (base) {
          controller.selectSuggest(base);
        },
      ),
    );
  }
}
