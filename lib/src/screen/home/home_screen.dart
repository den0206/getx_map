import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/home/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/Home';

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              TextButton(
                child: Text("検索"),
                onPressed: controller.stations.length < 2
                    ? null
                    : () {
                        controller.pushMapScreen();
                      },
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.stations.length,
                  itemBuilder: (context, index) {
                    final staion = controller.stations.elementAt(index);
                    return CommonCell(station: staion);
                  },
                ),
              ),
              if (controller.stations.length <= 5) CommonCell(),
            ],
          ),
        );
      },
    );
  }
}

class CommonCell extends GetView<HomeController> {
  const CommonCell({Key? key, this.station}) : super(key: key);

  final Station? station;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () {
                  controller.pushGetScreen(station);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      station == null ? "駅名を入力してください" : station!.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          station == null
              ? Icon(Icons.arrow_forward_ios)
              : CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 15,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      controller.removeStation(station);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
