import 'package:flutter/material.dart';

class LoadTextWidget extends StatelessWidget {
  const LoadTextWidget({super.key, required this.title, required this.color});
  final Color color;
  final double title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title.toStringAsFixed(2),
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
