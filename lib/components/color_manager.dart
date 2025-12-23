import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:pi_block/theme/app_colors.dart';

class ColorManager {
  final Map<String, Color> _assignedColors = {};
  final List<Color> _availableColors;
  final Random _random = Random();

  /// Determines if using dark colors
  final bool isDarkMode;

  ColorManager({required this.isDarkMode})
    : _availableColors = (isDarkMode
          ? KBarChartColors.darkBackgroundColors.values.toList()
          : KBarChartColors.lightBackgroundColors.values.toList());

  /// Get a color for a entity. Consistent across calls.
  Color getColorForEntity(String entityId) {
    if (_assignedColors.containsKey(entityId)) {
      return _assignedColors[entityId]!;
    }

    if (_availableColors.isEmpty) {
      // All colors used, reset by reshuffling
      _availableColors.addAll(
        isDarkMode
            ? KBarChartColors.darkBackgroundColors.values.toList()
            : KBarChartColors.lightBackgroundColors.values.toList(),
      );
      _availableColors.shuffle(_random);
    }

    // Pick a random color from available and remove it from the list
    int index = _random.nextInt(_availableColors.length);
    Color color = _availableColors.removeAt(index);

    _assignedColors[entityId] = color;
    return color;
  }

  void _resetColorPool() {
    _availableColors.addAll(
      isDarkMode
          ? KBarChartColors.darkBackgroundColors.values
          : KBarChartColors.lightBackgroundColors.values,
    );
    _availableColors.shuffle(_random);
  }

  /// Optional: reset all assignments
  void reset() {
    _assignedColors.clear();
    _resetColorPool();
  }
}
