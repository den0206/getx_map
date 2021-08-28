import 'package:flutter/material.dart';
import 'package:getx_map/src/screen/shop_detail/shop_detail_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/utils/common_icon.dart';

class ShopDetailScreen extends GetView<ShopDetailController> {
  const ShopDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/ShopDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
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
                // height: MediaQuery.of(context).size.height * 0.25,
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
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                          Chip(
                            label: Text(controller.shop.stationName),
                            labelStyle: TextStyle(fontWeight: FontWeight.w600),
                            avatar: Icon(
                              CommonIcon.stationIcon,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(controller.shop.address)
                        ],
                      ),
                      Row(
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
                      Text(
                        controller.shop.shopDetailMemo,
                        style: TextStyle(height: 1.5),
                      ),
                      Text(
                        controller.shop.charter,
                        style: TextStyle(height: 1.5),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "ホームページ",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ));
  }
}
