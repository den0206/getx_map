import 'package:flutter/material.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

class CommonChip extends StatelessWidget {
  const CommonChip({
    Key? key,
    required this.label,
    required this.selected,
    this.leadingIcon,
    this.onselected,
  }) : super(key: key);

  final String label;
  final bool selected;
  final Widget? leadingIcon;
  final Function(bool selected)? onselected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: ChoiceChip(
        labelPadding: EdgeInsets.symmetric(horizontal: 3.w),
        avatar: leadingIcon,
        backgroundColor: Colors.black,
        selectedColor: ColorsConsts.themeYellow,
        labelStyle: TextStyle(color: Colors.white),
        label: Text(label),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(3.sp),
        selected: selected,
        onSelected: onselected,
      ),
    );
  }
}
