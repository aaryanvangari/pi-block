import 'package:flutter/material.dart';
import 'app_ui_tokens.dart';

extension AppUiContext on BuildContext {
  AppUiTokens get ui {
    // This ensures Flutter knows this widget depends on Theme
    final theme = Theme.of(this);
    return theme.extension<AppUiTokens>()!;
  }
}
