import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_screen.dart';
import 'package:getx_map/src/screen/widget/common_chip.dart';
import 'package:getx_map/src/screen/widget/loading_widget.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/screen/map/map_controller.dart';

final double ksheetHeight = (Platform.isIOS) ? 300 : 275;

class MapScreen extends GetView<MapController> {
  MapScreen({Key? key}) : super(key: key);

  static const routeName = "/MapScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MapController>(
        init: MapController(),
        autoRemove: false,
        builder: (controller) {
          return OverlayLoadingWidget(
            isLoading: controller.overlayLoading,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      controller.mapService.initialCameraPosition,
                  padding: EdgeInsets.only(bottom: ksheetHeight - 30),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  markers: controller.mapService.markers,
                  circles: controller.mapService.circles,
                  onMapCreated: (map) async {
                    await controller.onMapCreate(map);
                  },
                  onLongPress: (latLng) async {
                    /// change center circle;
                    await controller.onMapLongPress(latLng);
                  },
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        leading: new IconButton(
                          iconSize: 32,
                          icon: new Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                          onPressed: () => Get.back(),
                        ),
                        backgroundColor:
                            Colors.transparent, //You can make this transparent
                        elevation: 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0),
                          height: MediaQuery.of(context).size.height * 0.05,
                          // height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: true,
                            itemCount: controller.stations.length,
                            itemBuilder: (context, index) {
                              final station = controller.stations[index];
                              return CommonChip(
                                label: station.name,
                                selected: controller.selectedIndex == index,
                                leadingIcon: Icon(
                                  Icons.person,
                                  color: ColorsConsts.iconColors[index],
                                ),
                                onselected: (selected) =>
                                    controller.selectedChip(index),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _defaultButton(),
                _zoomButtons(),
                MainBar(mapController: controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _zoomButtons() {
    return Positioned(
      bottom: ksheetHeight + 10,
      left: 20,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
              color: Colors.black87,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.add,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await controller.zoomUp();
              },
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              color: Colors.black87,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.remove,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await controller.zoomDown();
              },
            ),
          ],
        ),
      ),
    );
  }

  Positioned _defaultButton() {
    return Positioned(
      bottom: ksheetHeight - 10,
      right: 20,
      child: SafeArea(
        child: FloatingActionButton.extended(
          backgroundColor: ColorsConsts.themeYellow,
          // backgroundColor: Colors.green[300],
          onPressed: () {
            controller.mapService.fitMarkerBounds();
          },
          label: Text(
            'Default Position',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
