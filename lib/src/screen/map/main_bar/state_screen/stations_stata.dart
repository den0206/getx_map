import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/utils/common_icon.dart';

import '../origin_carousel.dart';
import 'package:sizer/sizer.dart';

class StationsState extends GetView<MainBarController> {
  const StationsState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: Obx(() => Text(
                "最寄り駅が${controller.nearStations.length}駅あります。",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                ),
              )),
        ),
        OriginCrousel(
          controller: controller.pageController,
          itemCount: controller.nearStations.length,
          onChange: (index) {
            controller.currentIndex.value = index;

            /// zoom near station
            controller.mapController
                .zoomStation(controller.nearStations[index]);
          },
          itemBuilder: (context, index) {
            final station = controller.nearStations[index];

            return Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 1.h, left: 3.w),
              child: InkResponse(
                onTap: () {
                  controller.selectStation(station);
                },
                child: Obx(() => Transform.scale(
                      scale: controller.currentIndex.value == index ? 1 : 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              CommonIcon.stationIcon,
                              color: Colors.green,
                              size: 35.sp,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "${station.name} 駅",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            if (station.distanceFromCenter != null)
                              Text("約 ${station.distanceFromCenter!} ")
                          ],
                        ),
                      ),
                    )),
              ),
            );
          },
        ),
      ],
    );
  }
}
