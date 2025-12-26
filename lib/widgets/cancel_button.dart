import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  VoidCallback? onPressed;
  CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text("Cancel"),
    );
  }
}
