import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/screen/map/main_bar/state_screen/distance_state.dart';
import 'package:getx_map/src/screen/map/main_bar/state_screen/favotite_shop_state.dart';
import 'package:getx_map/src/screen/map/main_bar/state_screen/menu_state.dart';
import 'package:getx_map/src/screen/map/main_bar/state_screen/route_state.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';

import 'state_screen/stations_stata.dart';

class MainBar extends GetView<MainBarController> {
  const MainBar({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 30.h + MediaQuery.of(context).viewPadding.bottom,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4.sp),
          child: GetX<MainBarController>(
            init: MainBarController(mapController),
            builder: (_) {
              switch (controller.currentState.value) {
                case MenuBarState.root:
                  return StationsState();
                case MenuBarState.distance:
                  return DistanceState();
                case MenuBarState.showMenu:
                  return MenuState();
                case MenuBarState.route:
                  return RouteState();
                case MenuBarState.favoriteShop:
                  return FavoriteShopState();
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

/// common header

class MenuBarHeader extends StatelessWidget {
  const MenuBarHeader({
    Key? key,
    required this.title,
    required this.onClose,
  }) : super(key: key);

  final String title;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
            ),
          ),
          Spacer(),
          InkResponse(
            onTap: onClose,
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
