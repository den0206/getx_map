import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_map/src/screen/get_station/search_station_abstract/search_abstract.dart';
import 'package:getx_map/src/screen/widget/animated_widget.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../map_controller.dart';
import 'package:sizer/sizer.dart';

class SearchPanel extends GetView<MapController> {
  const SearchPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SlidUpWidget(
        show: controller.showPanel.value,
        child: SlidingUpPanel(
          minHeight: 100 + MediaQuery.of(context).padding.bottom,
          controller: controller.panelController,
          color: Colors.grey[400]!,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          panelBuilder: (sc) {
            return AbstractSearchScreen(
              controller: controller,
              usePull: true,
              useAd: false,
              searchSpace: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.panelController.close();
                    },
                  ),
                  Container(
                    height: 8.h,
                    width: 70.w,
                    child: TextField(
                      controller: controller.tX,
                      decoration: InputDecoration(
                        icon: Icon(CommonIcon.stationIcon, color: Colors.black),
                        labelText: "駅名を検索",
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.black),
                        focusColor: Colors.black,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onTap: () {
                        controller.panelController.open();
                      },
                      onChanged: controller.queryChanged,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      controller.closePanel();
                    },
                  ),
                ],
              ),
              onSelect: (base) async {
                FocusScope.of(context).unfocus();
                await controller.selectSuggest(base);
              },
            );
          },
        ),
      );
    });
  }
}
