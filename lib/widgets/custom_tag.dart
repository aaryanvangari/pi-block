import 'package:flutter/material.dart';
import 'package:pi_block/data/notifiers.dart';

class CustomTagWidget extends StatelessWidget {
  CustomTagWidget({
    super.key,
    required this.title,
    this.iconData,
    this.color,
    this.titleColor,
    this.horizontalPadding = 2,
  });
  final IconData? iconData;
  final Color? color;
  final String title;
  final Color? titleColor;
  double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        decoration: BoxDecoration(
          color: tagBackground.value,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            iconData != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(iconData, size: 10, color: color),
                  )
                : SizedBox(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
