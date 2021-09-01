import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_screen.dart';
import 'package:getx_map/src/screen/widget/common_chip.dart';
import 'package:getx_map/src/screen/widget/custom_badges.dart';
import 'package:getx_map/src/screen/widget/loading_widget.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/screen/map/map_controller.dart';

class MapScreen extends GetView<MapController> {
  MapScreen({Key? key}) : super(key: key);

  static const routeName = "/MapScreen";
  final mainBarHeigh = 30.h;

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
                  padding: EdgeInsets.only(bottom: 30.h),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  markers: controller.mapService.markers,
                  circles: controller.mapService.circles,
                  polylines: controller.mapService.polylines,
                  onMapCreated: (map) async {
                    await controller.onMapCreate(map);
                  },
                  onLongPress: (latLng) async {
                    /// change center circle;
                    await controller.onMapLongPress(latLng);
                  },
                ),
                _chipArea(context, controller),
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

  Positioned _chipArea(BuildContext context, MapController controller) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            leading: new IconButton(
              iconSize: 28.sp,
              icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: AdmobBannerService.to.myBannerAd,
            backgroundColor: Colors.transparent, //You can make this transparent
            elevation: 0.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              height: 5.h,
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
                    selected: controller.chipIndex == index,
                    leadingIcon: CommonIcon.getPersonIcon(index),
                    onselected: (selected) => controller.selectedChip(index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomButtons() {
    return Positioned(
      bottom: mainBarHeigh + 30,
      left: 20,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                )),
            FavoriteShopBadge(
              onTap: () {
                controller.selectFavorite();
              },
            ),
            SizedBox(
              height: 1.h,
            ),
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
      bottom: mainBarHeigh + 10,
      right: 20,
      child: SafeArea(
        child: FloatingActionButton.extended(
          backgroundColor: ColorsConsts.themeYellow,
          // backgroundColor: Colors.green[300],
          onPressed: () {
            controller.degaultMap();
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
