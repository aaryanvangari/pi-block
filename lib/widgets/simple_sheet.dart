import 'package:flutter/material.dart';

class SimpleBottomSheet extends StatelessWidget {
  final BuildContext context;
  final String primaryTitle;
  final String confirmationText;
  final VoidCallback? primaryFunction;
  final VoidCallback? cancelFunction;
  final Color? backgroundColor;

  const SimpleBottomSheet({
    super.key,
    required this.primaryTitle,
    required this.context,
    required this.confirmationText,
    required this.primaryFunction,
    required this.cancelFunction,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(confirmationText, style: TextStyle(fontSize: 16))),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: primaryFunction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor:
                      backgroundColor ?? Theme.of(context).colorScheme.error,
                ),
                child: Text(primaryTitle),
              ),
              ElevatedButton(
                onPressed: cancelFunction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
