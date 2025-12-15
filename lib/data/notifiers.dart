import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<String> isDarkModeNotifier = ValueNotifier("Light");
ValueNotifier<int> notificationsNotifier = ValueNotifier(0);
ValueNotifier<Duration> blockedTimerNotifier = ValueNotifier(Duration());
ValueNotifier<bool> blockedExpandedStateNotifier = ValueNotifier(false);
ValueNotifier<bool> isBlockedEnabledNotifier = ValueNotifier(true);
ValueNotifier<Color> listHeaderBackground = ValueNotifier(Colors.transparent);
ValueNotifier<Color> listHeaderRedBackground = ValueNotifier(
  Colors.transparent,
);
ValueNotifier<Color> listHeaderGreenBackground = ValueNotifier(
  Colors.transparent,
);
ValueNotifier<Color> tagBackground = ValueNotifier(Colors.transparent);
ValueNotifier<TextStyle> listHeaderTitleAllow = ValueNotifier(TextStyle());
ValueNotifier<TextStyle> listHeaderTitleBlock = ValueNotifier(TextStyle());
ValueNotifier<Color> slidePrimary = ValueNotifier(Colors.transparent);
ValueNotifier<Color> slideError = ValueNotifier(Colors.transparent);
