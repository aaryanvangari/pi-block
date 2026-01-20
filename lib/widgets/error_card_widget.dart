import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_styles.dart';

class ErrorCardWidget extends StatelessWidget {
  const ErrorCardWidget({
    super.key,
    required this.header,
    required this.message,
  });
  final String message;
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 10, width: MediaQuery.sizeOf(context).width),
            Center(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
