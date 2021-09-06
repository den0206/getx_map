import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';

import '../main_bar_controller.dart';
import '../main_bar_screen.dart';
import '../origin_carousel.dart';

class FavoriteShopState extends GetView<MainBarController> {
  const FavoriteShopState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MenuBarHeader(
          title: "お気に入り",
          onClose: () => controller.currentState.value = MenuBarState.showMenu,
        ),
        OriginCrousel(
          controller: controller.pageController,
          itemCount: controller.favorites.length,
          onChange: (index) {
            controller.currentIndex.value = index;
            controller.mapController.zoomShop(controller.favorites[index]);
          },
          itemBuilder: (context, index) {
            final shop = controller.favorites[index];
            return Container(
              padding: EdgeInsets.only(top: 3.h, bottom: 1.h, left: 3.w),
              child: InkResponse(
                onTap: () {
                  controller.selectFavoriteShop(shop);
                },
                child: Obx(
                  () => Transform.scale(
                    scale: controller.currentIndex.value == index ? 1 : 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.white),
                        image: DecorationImage(
                          image: NetworkImage(shop.photo),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: new BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.1)),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.sp),
                                child: Text(
                                  shop.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
