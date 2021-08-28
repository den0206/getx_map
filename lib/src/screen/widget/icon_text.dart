import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.size,
  }) : super(key: key);

  final IconData icon;

  final String text;
  final Color? iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            icon,
            size: size ?? 40,
            color: iconColor ?? Colors.black,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(fontSize: 12),
          ),
        )
      ]),
    );
  }
}
