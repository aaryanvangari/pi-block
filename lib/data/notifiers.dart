import 'package:flutter/material.dart';
import 'package:pi_block/models/app_settings_model.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<String> isDarkModeNotifier = ValueNotifier("Light");
ValueNotifier<Duration> blockedTimerNotifier = ValueNotifier(Duration());
ValueNotifier<bool> blockedExpandedStateNotifier = ValueNotifier(false);
ValueNotifier<bool> isBlockedEnabledNotifier = ValueNotifier(true);
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
ValueNotifier<ThemeModeOption> themeModeOptionNotifier = ValueNotifier(
  ThemeModeOption.system,
);
final ValueNotifier<bool> isQuerylogSearchVisible = ValueNotifier(false);
