import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const routeName = '/MapScreen';

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    return Scaffold(
      body: GetBuilder<MapController>(
        init: MapController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: controller.service.initialCameraPosition,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                compassEnabled: false,
                padding: EdgeInsets.only(top: controller.service.topPadding),
                onMapCreated: controller.onMapCreated,
                markers: controller.service.markers,
                polylines: controller.service.polylines,
                polygons: controller.service.polygons,
                onTap: controller.onTap,
              ),
              Positioned(
                bottom: 35,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Text(
                            "Where are you going?",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        onPressed: () async {
                          await controller.toSearch();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
