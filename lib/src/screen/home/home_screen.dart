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
                    return StationCell(
                      station: staion,
                    );
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

class StationCell extends GetView<HomeController> {
  const StationCell({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 180,
            height: MediaQuery.of(context).size.height / 6.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1.0,
                    blurRadius: 10,
                    offset: Offset(10, 10))
              ],
            ),
            child: Card(
              color: Colors.grey[200],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.pushGetScreen(station);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_transit,
                            color: Colors.grey[400],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${station.name} 駅",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Expanded(
                        child: station.lines.isEmpty
                            ? TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                    )),
                                child: Text("路線を表示する"),
                                onPressed: () async {
                                  await controller.getStationInfo(station);
                                },
                              )
                            : ListView.builder(
                                itemCount: station.lines.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  final line = station.lines[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: line.lineColor,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          line.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
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
