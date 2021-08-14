import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_map/src/screen/search/search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = '/SearchScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        elevation: 0,
        actions: [
          CupertinoButton(
            child: Text("Save"),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _inputsFields(),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("AA"),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Column _inputsFields() {
    return Column(
      children: [
        SearchInput(
          controller: controller.originController,
          title: "Origin",
          enable: !controller.settedOrigin,
        ),
        SearchInput(
          controller: controller.destinationCOntroller,
          title: "Destination",
          enable: controller.settedOrigin,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
    required this.controller,
    required this.title,
    this.enable = true,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final bool enable;

  final Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
          labelText: title,
          labelStyle: TextStyle(color: Colors.black),
          focusColor: Colors.black,
          enabled: enable,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 5),
            child: CupertinoButton(
              padding: EdgeInsets.all(12),
              color: Colors.black38,
              child: Icon(Icons.close_outlined),
              onPressed: () {},
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
