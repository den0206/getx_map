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
                onPressed: controller.completeStations.length < 2
                    ? null
                    : () {
                        controller.pushMapScreen();
                      },
              )
            ],
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.group,
                                size: 20,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "現在の人数",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Text(
                        "${controller.completeStations.length.toString()} 人",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    )
                  ],
                ),
              ),
              if (controller.stations.length < 5)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 25,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          /// add empty cell;
                          controller.stations.add(null);
                        },
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.stations.length,
                  itemBuilder: (context, index) {
                    final staion = controller.stations.elementAt(index);
                    if (staion != null) {
                      return StationCell(
                        station: staion,
                      );
                    } else {
                      return EmptyCell(
                        index: index,
                      );
                    }
                  },
                ),
              ),
              // if (controller.stations.length <= 5) CommonCell(),
            ],
          ),
        );
      },
    );
  }
}

//

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
      child: Dismissible(
        key: Key(station.id),
        onDismissed: (direction) {
          controller.removeStation(station: station);
        },
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
                          final int selectedIndex =
                              controller.stations.indexOf(station);
                          controller.pushGetScreen(station, selectedIndex);
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final line = station.lines[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 30),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: line.lineColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                  controller.removeStation(station: station);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyCell extends GetView<HomeController> {
  const EmptyCell({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          controller.removeStation(index: index);
        },
        child: GestureDetector(
          onTap: () async {
            await controller.pushGetScreen(null, index);
          },
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                          "駅名を入力してください",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    controller.removeStation(index: index);
                    // controller.removeStation(station);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CommonCell extends GetView<HomeController> {
//   const CommonCell({Key? key, this.station}) : super(key: key);

//   final Station? station;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: InkWell(
//                 onTap: () {
//                   controller.pushGetScreen(station);
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 5,
//                         spreadRadius: 0.5,
//                         offset: Offset(0.7, 0.7),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Text(
//                       station == null ? "駅名を入力してください" : station!.name,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           station == null
//               ? Icon(Icons.arrow_forward_ios)
//               : CircleAvatar(
//                   backgroundColor: Colors.red,
//                   radius: 15,
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(Icons.close),
//                     color: Colors.white,
//                     onPressed: () {
//                       controller.removeStation(station);
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
