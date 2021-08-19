import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  static const routeName = "/MapScreen";
  final double ksheetHeight = (Platform.isIOS) ? 300 : 275;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MapController>(
        init: MapController(),
        autoRemove: false,
        builder: (controller) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: controller.service.initialCameraPosition,
                padding: EdgeInsets.only(bottom: ksheetHeight - 30),
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                onMapCreated: (map) async {
                  await controller.onMapCreate(map);
                },
                markers: controller.service.markers,
                circles: controller.service.circles,
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  backgroundColor:
                      Colors.transparent, //You can make this transparent
                  elevation: 0.0, //No shadow
                ),
              ),
              Positioned(
                bottom: ksheetHeight - 30,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                        ],
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          controller.service.fitMarkerBounds();
                        },
                        label: Text('My Location'),
                        icon: Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    height: ksheetHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        )
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.stations.length,
                      itemBuilder: (context, index) {
                        final staion = controller.stations[index];
                        return ListTile(
                          title: Center(child: Text(staion.name)),
                        );
                      },
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
