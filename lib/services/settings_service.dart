import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/constants/hive/hive_boxes.dart';

class SettingsService {
  // Singleton
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const _boxName = HiveBoxes.settings;
  static const _settingsKey = 'app_settings';

  AppSettingsModel? _cachedSettings;

  Box<AppSettingsModel> get _box => Hive.box<AppSettingsModel>(_boxName);

  AppSettingsModel getSettings() {
    if (_cachedSettings != null) return _cachedSettings!;
    final settings = _box.get(_settingsKey);
    _cachedSettings = settings ?? const AppSettingsModel();
    return _cachedSettings!;
  }

  Future<void> updateSettings(
    AppSettingsModel Function(AppSettingsModel) updater,
  ) async {
    final current = getSettings();
    final updated = updater(current);
    await _box.put(_settingsKey, updated);
    _cachedSettings = updated;
  }

  Future<void> clearSettings() async {
    await _box.delete(_settingsKey);
    _cachedSettings = null;
  }

  ThemeMode getThemeMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }
}
