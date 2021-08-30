import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/utils/common_icon.dart';

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
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              )),
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
              onPress: () {
                controller.searchRoute();
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
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "お気に入り",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(shop.photo),
                                fit: BoxFit.cover,
                              ),
                            )),
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
                  fontSize: 20,
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
                            size: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "${controller.currentNearStation.name}への経路",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    )),
                    Text(
                      "からの",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "行き方",
                        style: TextStyle(fontSize: 20, color: Colors.yellow),
                      ),
                      onPressed: () {
                        controller.openUrl(index);
                      },
                    ),
                    Text(
                      controller.requireTimeString(index),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        margin: EdgeInsets.all(8),
        width: ksheetHeight * 0.5,
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
