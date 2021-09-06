import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_map/src/utils/common_icon.dart';

import '../main_bar_controller.dart';
import 'package:sizer/sizer.dart';

import '../main_bar_screen.dart';
import '../origin_carousel.dart';

class DistanceState extends GetView<MainBarController> {
  const DistanceState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuBarHeader(
          title: "中間移転への距離",
          onClose: () => controller.currentState.value = MenuBarState.showMenu,
        ),
        OriginCrousel(
          controller: controller.pageController,
          itemCount: controller.mapController.stations.length,
          onChange: (index) {
            controller.mapController.selectedChip(index);
          },
          itemBuilder: (context, index) {
            final station = controller.mapController.stations[index];

            return Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 1.h, left: 3.w),
              child: InkResponse(
                onTap: () {
                  controller.mapController.selectedChip(index);
                },
                child: Obx(
                  () => Transform.scale(
                    scale: controller.mapController.chipIndex.value == index
                        ? 1
                        : 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonIcon.getPersonIcon(index, size: 7.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              station.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          if (station.distanceFromCenter != null)
                            Text(
                              "約 ${station.distanceFromCenter!} ",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight:
                                    controller.mapController.chipIndex.value ==
                                            index
                                        ? FontWeight.w700
                                        : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
