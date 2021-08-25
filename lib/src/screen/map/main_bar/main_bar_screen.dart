import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';

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
        height: ksheetHeight,
        margin: EdgeInsets.symmetric(horizontal: 8),
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
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: GetX<MainBarController>(
            init: MainBarController(mapController),
            builder: (_) {
              switch (controller.currentState.value) {
                case MenuBarState.root:
                  return StationsState();
                case MenuBarState.showMenu:
                  return MenuState();

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
          child: Text(
            "${controller.currentNearStation.name} 駅",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
        ),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 21.0,
          crossAxisSpacing: 21.0,
          crossAxisCount: 3,
          children: [
            MenuButton(
              child: Text("経路検索"),
              onPress: () {},
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
                controller.backtate();
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
          child: Text(
            "最寄り駅",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.nearStations.length,
            itemBuilder: (context, index) {
              final station = controller.nearStations[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: InkResponse(
                  onTap: () {
                    controller.selectStation(station);
                  },
                  child: Obx(() => Transform.scale(
                        scale: controller.currentIndex.value == index ? 1 : 0.8,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          width: ksheetHeight * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.directions_transit,
                                size: 45,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  station.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              if (station.distance != null)
                                Text("約 ${station.distance!} "),
                            ],
                          ),
                        ),
                      )),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
