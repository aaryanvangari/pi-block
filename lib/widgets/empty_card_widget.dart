import 'package:flutter/material.dart';

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({
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
        padding: EdgeInsets.all(16),
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
                  // color: Theme.of(context).colorScheme.primary,
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
