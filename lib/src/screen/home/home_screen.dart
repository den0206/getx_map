import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/home/home_controller.dart';
import 'package:getx_map/src/screen/widget/animated_widget.dart';
import 'package:getx_map/src/screen/widget/custom_badges.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:getx_map/src/utils/consts_color.dart';

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
              FavoriteShopBadge(),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
                child: Text(
                  "検索",
                ),
                onPressed: controller.completeStations.length < 2
                    ? null
                    : () {
                        controller.pushMapScreen();
                      },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 6.5,
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
                                  size: 35,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: "現在の人数",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
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
                              fontSize: 40, fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AdmobBannerService.to.myBannerAd,
                    if (controller.stations.length < 5)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add),
                            color: ColorsConsts.themeYellow,
                            onPressed: () {
                              /// add empty cell;
                              controller.stations.add(null);
                            },
                          ),
                        ),
                      ),
                  ],
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
                          index: index,
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
    required this.index,
  }) : super(key: key);

  final Station station;
  final int index;

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey,
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
                              CommonIcon.stationIcon,
                              color: Colors.black,
                              // color: Colors.grey[400],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 120),
                              child: Text(
                                "${station.name} 駅",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 10,
                              // color: Colors.grey[400],
                            ),
                            Spacer(),
                            Icon(
                              Icons.person,
                              size: 40,
                              color: ColorsConsts.iconColors[index]
                                  .withOpacity(0.8),
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
                                  child: Text(
                                    "路線を表示する",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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
                                      child: Chip(
                                        backgroundColor: line.lineColor,
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        label: Text(
                                          line.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
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
    return FadeinWidget(
      child: Padding(
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: ColorsConsts.iconColors[index]
                                  .withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Icon(
                                  CommonIcon.stationIcon,
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
                          Spacer(),
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
      ),
    );
  }
}

 // BackgroundVideoScreen(videoPath: "assets/videos/station-0.mp4"),


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
