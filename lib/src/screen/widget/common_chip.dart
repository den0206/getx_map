import 'package:flutter/material.dart';
import 'package:getx_map/src/utils/consts_color.dart';

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
        labelPadding: EdgeInsets.all(5.0),
        avatar: leadingIcon,
        backgroundColor: Colors.black,
        selectedColor: ColorsConsts.themeYellow,
        labelStyle: TextStyle(color: Colors.white),
        label: Text(label),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(6),
        selected: selected,
        onSelected: onselected,
      ),
    );
  }
}
