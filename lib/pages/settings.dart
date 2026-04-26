import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pi_block/services/settings_service.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/app_settings_model.dart';
import 'package:pi_block/theme/app_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeModeOption _currentMode;
  late AppSettingsModel appSettingsModel;

  void loadSettings() async {
    _currentMode = SettingsService().getSettings().themeModeOption;
  }

  void _onThemeModeChanged(ThemeModeOption? value) async {
    if (value == null) return;
    await SettingsService().updateSettings(
      (appSettingsModel) => appSettingsModel.copyWith(themeModeOption: value),
    );
    // Notifying app about theme change through notifiers
    ThemeMode themeMode = SettingsService().getThemeMode(value);

    // app theme notifier
    themeModeNotifier.value = themeMode;

    // theme option notifier so be in sync with dark/light icon in home page
    themeModeOptionNotifier.value = value;

    // setting state of app so that dropdown change is reflected
    setState(() {
      _currentMode = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Text(
                      "Application Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Theme", style: TextStyle(fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ThemeModeOption>(
                          borderRadius: BorderRadius.circular(10),
                          style: Theme.of(context).textTheme.bodyMedium,
                          value: _currentMode,
                          items: [
                            DropdownMenuItem(
                              value: ThemeModeOption.system,
                              child: Text("System"),
                            ),
                            DropdownMenuItem(
                              value: ThemeModeOption.light,
                              child: Text("Light"),
                            ),
                            DropdownMenuItem(
                              value: ThemeModeOption.dark,
                              child: Text("Dark"),
                            ),
                          ],
                          onChanged: _onThemeModeChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              KDivider.sectionDivider,
            ],
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform().then((info) => info),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                var packageInfo = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Version: ${packageInfo.version.toString()}'),
                      Text('Build: ${packageInfo.buildNumber.toString()}'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
