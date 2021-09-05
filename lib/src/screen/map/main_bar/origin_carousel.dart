import 'package:flutter/material.dart';

class OriginCrousel extends StatefulWidget {
  OriginCrousel({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onChange,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _OriginCrouselState createState() => _OriginCrouselState();

  final PageController controller;
  final int itemCount;

  final Function(int index) onChange;
  final Widget Function(BuildContext context, int index) itemBuilder;
}

class _OriginCrouselState extends State<OriginCrousel> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = widget.controller.initialPage;
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      child: PageView.builder(
        itemCount: widget.itemCount,
        controller: widget.controller,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
          widget.onChange(index);
        },
        itemBuilder: widget.itemBuilder,
      ),
    ));
  }
}
