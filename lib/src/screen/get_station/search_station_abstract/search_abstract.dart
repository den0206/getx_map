import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:getx_map/src/utils/common_icon.dart';

abstract class GetxSearchController extends GetxController {
  RxList<Suggest> suggestions = RxList<Suggest>();
  RxList<Station> predicts = RxList<Station>();

  final FocusNode focusNode = FocusNode();
  final TextEditingController tX = TextEditingController();

  final stationAPI = StaionAPI();

  final database = DatabaseService.to;
  String _searchText = "";
  Timer? _searchTimer;

  bool get noSuggest {
    return suggestions.isEmpty;
  }

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
  }

  void queryChanged(String text) {
    suggestions.clear();

    _searchText = text;
    _searchTimer?.cancel();

    try {
      if (_searchText.length >= 2)
        _searchTimer = Timer(Duration(seconds: 1), () async {
          final temp = await stationAPI.getStationSuggestion(_searchText);
          suggestions.addAll(temp);
        });
    } catch (e) {
      print(e.toString());
    }
  }

  void loadDatabse() {
    final def = database.loadStations(DatabaseKey.search);
    predicts.addAll(def);
  }

  void saveDatabase(Station station) {
    if (!predicts.contains(station)) {
      predicts.add(station);
      database.setStationList(DatabaseKey.search, predicts);
    }
  }

  void deleteDatabase(StationBase base) {
    if (base is Station) {
      predicts.remove(base);
      database.setStationList(DatabaseKey.search, predicts);
    }
  }
}

/// screen
class AbstractSearchScreen extends StatelessWidget {
  const AbstractSearchScreen({
    Key? key,
    required this.controller,
    required this.onSelect,
    this.usePull = false,
    this.useAd = true,
    this.searchSpace,
  }) : super(key: key);

  final GetxSearchController controller;

  final Function(StationBase base) onSelect;
  final bool usePull;
  final bool useAd;
  final Row? searchSpace;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Column(
          children: [
            if (usePull)
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            Padding(
              padding: EdgeInsets.all(8),
              child: searchSpace ??
                  Row(
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
                          await onSelect(base);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            if (useAd) AdmobBannerService.to.myBannerAd,
          ],
        ),
      ),
    );
  }
}
