import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:sizer/sizer.dart';

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

class DistanceState extends GetView<MainBarController> {
  const DistanceState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "中間移転への距離",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  controller.backRoot();
                },
              )
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.mapController.stations.length,
            itemBuilder: (context, index) {
              final station = controller.mapController.stations[index];
              return InkResponse(
                onTap: () {
                  controller.selectpolyline(index);
                },
                child: Obx(
                  () => Transform.scale(
                    scale: controller.mapController.chipIndex.value == index
                        ? 1
                        : 0.8,
                    child: BoxCell(
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
                            Text("約 ${station.distanceFromCenter!} ",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: controller
                                              .mapController.chipIndex.value ==
                                          index
                                      ? FontWeight.w700
                                      : null,
                                )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MenuState extends GetView<MainBarController> {
  const MenuState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Obx(() => Text(
                "${controller.currentNearStation.name} 駅",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              )),
        ),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 21.0.sp,
          crossAxisSpacing: 21.0.sp,
          crossAxisCount: 3,
          children: [
            MenuButton(
              child: Text("経路検索"),
              onPress: () {
                controller.confirmRoute();
              },
            ),
            MenuButton(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/icon/get_map_icon_0.png",
                  )),
              child: Container(),
              onPress: () {
                controller.pushShopScreen();
              },
            ),
            MenuButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.undo,
                    size: 40,
                  ),
                  Text("戻る"),
                ],
              ),
              onPress: () {
                controller.backRoot();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.child,
    required this.onPress,
    this.image,
  }) : super(key: key);

  final Widget child;
  final Function() onPress;
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.black, width: 2),
          image: image ?? null),
      child: IconButton(
        icon: child,
        onPressed: onPress,
      ),
    );
  }
}

class FavoriteShopState extends GetView<MainBarController> {
  const FavoriteShopState({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "お気に入り",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  controller.currentState.value = MenuBarState.showMenu;
                },
              )
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: controller.favorites.length,
            itemBuilder: (context, index) {
              final shop = controller.favorites[index];
              return InkResponse(
                onTap: () {
                  controller.selectFavoriteShop(shop);
                },
                child: Obx(
                  () => Transform.scale(
                    scale: controller.currentIndex.value == index ? 1 : 0.8,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.,
                      children: [
                        Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(shop.photo),
                                fit: BoxFit.cover,
                              ),
                            )),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          shop.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
          padding: const EdgeInsets.only(top: 8),
          child: Obx(() => Text(
                "最寄り駅が${controller.nearStations.length}駅あります。",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                ),
              )),
        ),
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.nearStations.length,
            itemBuilder: (context, index) {
              final station = controller.nearStations[index];
              return InkResponse(
                onTap: () {
                  controller.selectStation(station);
                },
                child: Obx(
                  () => Transform.scale(
                    scale: controller.currentIndex.value == index ? 1 : 0.8,
                    child: BoxCell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CommonIcon.stationIcon,
                            color: Colors.green,
                            size: 35.sp,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              station.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          if (station.distanceFromCenter != null)
                            Text("約 ${station.distanceFromCenter!} "),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RouteState extends GetView<MainBarController> {
  const RouteState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "${controller.currentNearStation.name}への経路",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  controller.currentState.value = MenuBarState.showMenu;
                },
              )
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.mapController.stations.length,
            itemBuilder: (context, index) {
              final station = controller.mapController.stations[index];

              return BoxCell(
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
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BoxCell extends GetView<MainBarController> {
  const BoxCell({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 3.w + MediaQuery.of(context).viewPadding.bottom),
      child: Container(
        width: 35.w,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1),
        ),
        child: child,
      ),
    );
  }
}
