import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';

import '../main_bar_controller.dart';

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
