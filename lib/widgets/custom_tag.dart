import 'package:flutter/material.dart';

class CustomTagWidget extends StatelessWidget {
  const CustomTagWidget({
    super.key,
    required this.title,
    this.iconData,
    this.color,
  });
  final IconData? iconData;
  final Color? color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          iconData != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(iconData, size: 10, color: color),
          ): SizedBox(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
