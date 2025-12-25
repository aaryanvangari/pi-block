import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_ui_context.dart';

class CircularLoaderInButton extends StatelessWidget {
  const CircularLoaderInButton({super.key});

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          context.ui.circularLoadingOnPrimary,
        ),
        strokeWidth: 3,
      ),
    );
  }
}
