import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_styles.dart';

class WaitingCardWidget extends StatelessWidget {
  const WaitingCardWidget({super.key, required this.header});
  final String header;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: KCardStyle.actionsCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10, width: MediaQuery.sizeOf(context).width),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
