import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoIconButton extends StatelessWidget {
  final String title;
  final String message;
  final double iconSize;

  const InfoIconButton({
    super.key,
    required this.title,
    required this.message,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.info_outline,
      size: iconSize,
    );

    // iOS → Cupertino dialog
    if (Platform.isIOS) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(message),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: SizedBox(
          width: iconSize + 4,
          height: iconSize + 4,
          child: Center(child: icon),
        ),
      );
    }

    // Android / Desktop → Tooltip
    return Tooltip(
      message: message,
      preferBelow: false,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(20),
      child: icon,
    );
  }
}
