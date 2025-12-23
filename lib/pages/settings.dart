import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void onDarkModeChanged(String value, String isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value == "Dark") {
      isDarkMode = "Dark";
    } else if (value == "Light") {
      isDarkMode = "Light";
    } else if (value == "System") {
      isDarkMode = "System";
    }
    setState(() {
      darkMode = value;
      isDarkModeNotifier.value = isDarkMode;
    });
    prefs.setString(KConstants.themeModeKey, isDarkMode);
  }

  String? darkMode;

  void loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var themeMode = prefs.getString(KConstants.themeModeKey);

    setState(() {
      darkMode = (themeMode == null) ? "System" : themeMode;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/home");
          },
        ),
      ),
      body: SingleChildScrollView(
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Theme", style: TextStyle(fontSize: 16)),
                      ValueListenableBuilder(
                        valueListenable: isDarkModeNotifier,
                        builder: (context, isDarkMode, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: darkMode,
                                items: [
                                  DropdownMenuItem(
                                    value: "System",
                                    child: Text("System"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Light",
                                    child: Text("Light"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Dark",
                                    child: Text("Dark"),
                                  ),
                                ],
                                onChanged: (value) =>
                                    onDarkModeChanged(value!, isDarkMode),
                              ),
                            ),
                          );
                        },
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
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var packageInfo = snapshot.data;
                  widget = Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Version: ${packageInfo.version.toString()}'),
                        Text('Build: ${packageInfo.buildNumber.toString()}'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = SizedBox();
                } else {
                  widget = SizedBox();
                }
                return widget;
              },
            ),
          ],
        ),
      ),
    );
  }
}
