import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/widget/common_chip.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/screen/map/map_controller.dart';

class MapScreen extends GetView<MapController> {
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
                markers: controller.service.markers,
                circles: controller.service.circles,
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
                        icon:
                            new Icon(Icons.arrow_back_ios, color: Colors.black),
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
              if (controller.showMenu) _menuBar()
            ],
          );
        },
      ),
    );
  }

  Positioned _menuBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            controller.toggleMenuBar();
          } else if (details.delta.dy < -sensitivity) {
            print("Up");
          }
        },
        child: Container(
          height: ksheetHeight,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("最寄り駅"),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.nearStations.length,
                  itemBuilder: (context, index) {
                    final station = controller.nearStations[index];
                    return ListTile(
                      title: Center(
                        child: Text(station.name),
                      ),
                      onTap: () {
                        controller.zoomStation(station);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
      ),
    );
  }

  Positioned _defaultButton() {
    return Positioned(
      bottom: ksheetHeight - 10,
      right: 20,
      child: SafeArea(
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green[300],
          onPressed: () {
            controller.service.fitMarkerBounds();
          },
          label: Text('Default Position'),
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
