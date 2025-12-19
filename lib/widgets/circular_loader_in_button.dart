import 'package:flutter/material.dart';
import 'package:pi_block/data/notifiers.dart';

class CircularLoaderInButton extends StatelessWidget {
  const CircularLoaderInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          circularLoadingOnPrimary.value,
        ),
        strokeWidth: 3,
      ),
    );
  }
}
