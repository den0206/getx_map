import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/get_station/get_station_controller.dart';
import 'package:getx_map/src/utils/common_icon.dart';

class GetStationScreen extends GetView<GetStationController> {
  const GetStationScreen({Key? key}) : super(key: key);

  static const routeName = '/GetStation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: controller.focusNode,
                        controller: controller.tX,
                        decoration: InputDecoration(
                          labelText: "駅名を検索",
                          labelStyle: TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: controller.queryChanged,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              Obx(
                () => Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: controller.noSuggest
                        ? controller.predicts.length
                        : controller.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final base = controller.noSuggest
                          ? controller.predicts.reversed.toList()[index]
                          : controller.suggestions[index];

                      return Slidable(
                        key: Key(base.id),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: controller.noSuggest
                            ? [
                                IconSlideAction(
                                  caption: 'delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    controller.deleteDatabase(base);
                                  },
                                ),
                              ]
                            : null,
                        child: ListTile(
                          leading: Icon(CommonIcon.stationIcon),
                          title: Text(base.name),
                          onTap: () async {
                            await controller.selectSuggest(base);
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
