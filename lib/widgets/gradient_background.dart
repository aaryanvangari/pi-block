import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 116, 187, 119), Color.fromARGB(255, 99, 188, 120)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        ),
      ),
      child: child,
    );
  }
}
