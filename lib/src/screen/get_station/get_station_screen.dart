import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/screen/get_station/get_station_controller.dart';

class GetStationScreen extends GetView<GetStationController> {
  const GetStationScreen({Key? key}) : super(key: key);

  static const routeName = '/GetStation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
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
            Obx(
              () => Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: controller.suggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final suggest = controller.suggestions[index];
                    return ListTile(
                      title: Text(suggest.name),
                      onTap: () async {
                        await controller.selectSuggest(suggest);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
