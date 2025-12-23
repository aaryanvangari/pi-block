import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/custom_pie_chart.dart';

class SquareCardPiechartWidget extends StatelessWidget {
  final String title;
  final List<PieData> items;
  const SquareCardPiechartWidget({
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
            CustomPieChart(
              space: 2,
              horizontalLine: 10,
              outerMargin: 20,
              data: items,
            ),
          ],
        ),
      ),
    );
  }
}
