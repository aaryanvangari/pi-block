import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_ui_tokens.dart';

class CircularLoaderInButton extends StatelessWidget {
  const CircularLoaderInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).extension<AppUiTokens>()!.circularLoadingOnPrimary,
        ),
        strokeWidth: 3,
      ),
    );
  }
}
