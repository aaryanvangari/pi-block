import 'package:flutter/material.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';

class TimeAgoWidget extends StatelessWidget {
  const TimeAgoWidget({super.key, required this.time});
  final int time;

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(Icons.update, size: 14),
        ),
        Text(
          PiUtils.getTimeAgo(time, "milliseconds"),
          style: KTextStyle.listHeaderTimeTitle,
        ),
      ],
    );
  }
}
