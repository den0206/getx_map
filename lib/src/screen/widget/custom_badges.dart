import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_shop_screen.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:get/get.dart';

class FavoriteShopBadge extends StatelessWidget {
  const FavoriteShopBadge({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? onTap
          : () {
              Get.toNamed(FavoriteShopScreen.routeName);
            },
      child: Badge(
        badgeColor: ColorsConsts.favoritebadgeColor,
        animationType: BadgeAnimationType.slide,
        toAnimate: true,
        badgeContent: Obx(
          () => Text(
            FavoriteShopService.to.favoriteShop.length.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        position: BadgePosition.topEnd(top: 2, end: -4),
        child: Icon(
          Icons.restaurant,
          color: ColorsConsts.favoritebadgeColor,
          size: 35,
        ),
      ),
    );
  }
}
