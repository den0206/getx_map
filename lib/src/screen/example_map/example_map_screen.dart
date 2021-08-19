import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/example_map/exapmple_map_controller.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExampleMapScreen extends StatelessWidget {
  const ExampleMapScreen({Key? key}) : super(key: key);
  static const routeName = '/ExampleMapScreen';

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    return Scaffold(
      body: GetBuilder<ExampleMapController>(
        init: ExampleMapController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: controller.service.initialCameraPosition,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                padding: EdgeInsets.only(bottom: controller.service.topPadding),
                onMapCreated: controller.onMapCreated,
                markers: controller.service.markers,
                polylines: controller.service.polylines,
                polygons: controller.service.polygons,
                circles: controller.service.circles,
              ),
              Positioned(
                bottom: 35,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoButton(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black87,
                        ),
                        onPressed: () async {
                          await controller.zoomUp();
                        },
                      ),
                      const SizedBox(height: 5),
                      CupertinoButton(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black87,
                        ),
                        onPressed: () async {
                          await controller.zoomDown();
                        },
                      ),
                      const SizedBox(height: 20),
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
