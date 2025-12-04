import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<String> isDarkModeNotifier = ValueNotifier("Light");
ValueNotifier<int> notificationsNotifier = ValueNotifier(0);
ValueNotifier<Duration> blockedTimerNotifier = ValueNotifier(Duration());
// ValueNotifier<int> blockedTimerAddedAtNotifier = ValueNotifier(0);
ValueNotifier<bool> blockedExpandedStateNotifier = ValueNotifier(false);
ValueNotifier<bool> isBlockedEnabledNotifier = ValueNotifier(true);
ValueNotifier<Color> listHeaderBackground = ValueNotifier(Colors.transparent);
ValueNotifier<Color> listHeaderRedBackground = ValueNotifier(Colors.transparent);
ValueNotifier<Color> listHeaderGreenBackground = ValueNotifier(Colors.transparent);

