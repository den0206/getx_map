import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_screen.dart';
import 'package:getx_map/src/screen/map/main_bar/origin_carousel.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:sizer/sizer.dart';

import '../main_bar_controller.dart';

class RouteState extends GetView<MainBarController> {
  const RouteState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MenuBarHeader(
          title: "${controller.currentNearStation.name}への経路",
          onClose: () => controller.currentState.value = MenuBarState.showMenu,
        ),
        OriginCrousel(
          controller: controller.pageController,
          itemCount: controller.mapController.stations.length,
          onChange: (index) {
            // controller.currentIndex.value = index;
          },
          itemBuilder: (context, index) {
            final station = controller.mapController.stations[index];
            return Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 1.h, left: 4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CommonIcon.getPersonIcon(index),
                        Container(
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Text(
                            "${station.name}駅 ",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    )),
                    Text(
                      "からの",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.openUrl(index);
                      },
                      child: Text(
                        "行き方",
                        style: TextStyle(fontSize: 13.sp, color: Colors.blue),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        controller.requireTimeString(index),
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
