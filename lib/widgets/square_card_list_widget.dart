import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_styles.dart';

class SquareCardListWidget extends StatelessWidget {
  final String title;
  final Widget items;
  const SquareCardListWidget({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: KCardStyle.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.99,
              child: Padding(padding: const EdgeInsets.all(8.0), child: items),
            ),
          ],
        ),
      ),
    );
  }
}
