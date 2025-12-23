import 'package:flutter/material.dart';
import 'package:pi_block/data/constants.dart';

class RowWithProgressbar extends StatelessWidget {
  final String title;
  final int count;
  final int total;
  final bool isBlocked;
  final Color progressBarColor;
  const RowWithProgressbar({
    super.key,
    required this.title,
    required this.count,
    required this.total,
    required this.isBlocked,
    required this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Tooltip(
                    message:
                        '${((count / total) * 100).toInt()}% - $count of $total',
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(20),
                    verticalOffset: 5,
                    preferBelow: false,
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      left: 2,
                      right: 2,
                      bottom: 4,
                    ),
                    child: LinearProgressIndicator(
                      backgroundColor: KColors.linearProgressbarBackground,
                      borderRadius: BorderRadius.circular(25),
                      color: progressBarColor,
                      minHeight: 2,
                      value: (count / total),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
