import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

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

class OriginCarouselCell extends StatelessWidget {
  const OriginCarouselCell(
      {Key? key,
      required this.child,
      required this.onTap,
      required this.currentIndex,
      required this.index,
      this.backGroundImage})
      : super(key: key);

  final Widget child;
  final RxnInt? currentIndex;
  final int? index;
  final VoidCallback onTap;
  final DecorationImage? backGroundImage;

  double get scale {
    if (currentIndex != null && index != null) {
      return currentIndex!.value == index ? 0.7 : 0.5;
    }

    return 0.7;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 3.h, left: 3.w),
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1),
                image: backGroundImage,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
