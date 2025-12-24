import 'package:flutter/material.dart';
import 'package:pi_block/models/app_settings_model.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<String> isDarkModeNotifier = ValueNotifier("Light");
ValueNotifier<Duration> blockedTimerNotifier = ValueNotifier(Duration());
ValueNotifier<bool> blockedExpandedStateNotifier = ValueNotifier(false);
ValueNotifier<bool> isBlockedEnabledNotifier = ValueNotifier(true);
ValueNotifier<Color> tagBackground = ValueNotifier(Colors.transparent);
ValueNotifier<TextStyle> listHeaderTitleAllow = ValueNotifier(TextStyle());
ValueNotifier<TextStyle> listHeaderTitleBlock = ValueNotifier(TextStyle());
ValueNotifier<Color> slidePrimary = ValueNotifier(Colors.transparent);
ValueNotifier<Color> slideError = ValueNotifier(Colors.transparent);
ValueNotifier<Color> circularLoadingOnPrimary = ValueNotifier(
  Colors.transparent,
);
ValueNotifier<Color> circularLoadingOnError = ValueNotifier(Colors.transparent);
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
ValueNotifier<ThemeModeOption> themeModeOptionNotifier = ValueNotifier(
  ThemeModeOption.system,
);
