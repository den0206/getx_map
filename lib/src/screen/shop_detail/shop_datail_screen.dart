import 'package:flutter/material.dart';
import 'package:getx_map/src/screen/shop_detail/shop_detail_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/widget/icon_text.dart';
import 'package:getx_map/src/utils/common_icon.dart';

class ShopDetailScreen extends GetView<ShopDetailController> {
  const ShopDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/ShopDetail';

  @override
  Widget build(BuildContext context) {
    final responsive = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: responsive.width - 20,
                  minHeight: responsive.height / 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1.0,
                            blurRadius: 20,
                            offset: Offset(5, 3))
                      ],
                    ),
                    child: Image.network(
                      controller.shop.photo,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(controller.shop.stationName),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        avatar: Icon(
                          CommonIcon.stationIcon,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 3,
                            ),
                            child: Text(
                              controller.shop.address,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      controller.shop.catchCopy,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            controller.shop.name,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 30),
                          ),
                        ),
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              controller.toggeleFavorite();
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: controller.shop.isFavorite
                                  ? Colors.redAccent
                                  : Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Chip(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        label: Text(controller.shop.avarage),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        avatar: Icon(
                          Icons.payments_outlined,
                        ),
                      ),
                      Chip(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        label: Text(controller.shop.genre.name),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        avatar: Icon(
                          Icons.restaurant_menu_rounded,
                        ),
                      ),
                    ],
                  ),
                  IconText(
                    icon: Icons.no_meals,
                    text: controller.shop.close,
                    iconColor: Colors.red,
                  ),
                  _divider(),
                  IconText(
                    icon: Icons.directions_walk_outlined,
                    text: controller.shop.access,
                    iconColor: Colors.green,
                  ),
                  _divider(),
                  if (controller.shop.shopDetailMemo.isNotEmpty) ...[
                    IconText(
                      icon: Icons.message_outlined,
                      text: controller.shop.shopDetailMemo,
                      iconColor: Colors.orange,
                    ),
                    _divider(),
                  ],
                  IconText(
                    icon: Icons.smoking_rooms_outlined,
                    text: controller.shop.smoking,
                    iconColor: Colors.black,
                  ),
                  _divider(),
                  IconText(
                    icon: Icons.wifi,
                    text: controller.shop.wifi,
                    iconColor: Colors.blue,
                  ),
                  _divider(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "ホームページ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ));
  }

  Padding _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        color: Colors.black,
        height: 2,
      ),
    );
  }
}
