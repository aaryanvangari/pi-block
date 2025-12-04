import 'dart:developer';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/data/notifiers.dart';
import 'dart:convert';

import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool loading = false;
  bool isBlockingEnabled = false;
  PiHttpClient piHttpClient = PiHttpClient();
  bool blockingExpansionTileEnabled = true;
  bool blockingExpandedState = false;
  List blockingTimes = [
    ["10 Seconds", 10],
    ["30 Seconds", 30],
    ["1 Minute", 60],
    ["5 Minutes", 300],
    ["10 Minutes", 600],
    ["30 Minutes", 1800],
    ["1 Hour", 3600],
    ["5 Hours", 18000],
  ];
  Duration blockingDuration = Duration(seconds: 0);
  ExpansibleController blockingExpansibleController = ExpansibleController();

  @override
  void dispose() {
    blockingExpansibleController.dispose();
    super.dispose();
  }

  Future<void> onBlockingChanged(bool status, int? timer) async {
    try {
      var body = jsonEncode(<String, dynamic>{
        "blocking": status,
        "timer": timer,
      });

      var result = await piHttpClient.post(KUrls.dns, body);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.onBlockingChanged",
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result["timer"] != null) {
        await prefs.setInt(
          KConstants.blockingTimer,
          Duration(seconds: result["timer"]).inSeconds,
        );
        await prefs.setInt(
          KConstants.blockingTimerAddedAt,
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      isBlockedEnabledNotifier.value = (result["blocking"] == "enabled")
          ? true
          : false;
      // Add 1 more second to make sure it's timer mismatch doesn't occur. Research on it thoroughly
      blockedTimerNotifier.value = Duration(seconds: result["timer"] ?? 0 + 1 ?? 0);
      blockingExpansibleController.collapse();
    } catch (e) {
      if (!mounted) return;
      PiUtils.handleGeneralException(context, e);
    }
  }

  bool getIsUpdateAvailable(dynamic version) {
    var coreLocal = version["version"]["core"]["local"]["version"].toString();
    var coreRemote = version["version"]["core"]["remote"]["version"].toString();
    var webLocal = version["version"]["web"]["local"]["version"].toString();
    var webRemote = version["version"]["web"]["remote"]["version"].toString();
    var ftlLocal = version["version"]["ftl"]["local"]["version"].toString();
    var ftlRemote = version["version"]["ftl"]["remote"]["version"].toString();
    var dockerLocal = version["version"]["docker"]["local"].toString();
    var dockerRemote = version["version"]["docker"]["remote"].toString();
    bool coreUpdate = false;
    bool webUpdate = false;
    bool ftlUpdate = false;
    bool dockerUpdate = false;
    bool updateAvailable = false;
    if (coreLocal != coreRemote) coreUpdate = true;
    if (webLocal != webRemote) webUpdate = true;
    if (ftlLocal != ftlRemote) ftlUpdate = true;
    if (dockerLocal != dockerRemote) dockerUpdate = true;

    if (coreUpdate || webUpdate || ftlUpdate || dockerUpdate) {
      updateAvailable = true;
    }
    return updateAvailable;
  }

  String getMemoryInfo(String type, dynamic item) {
    String memoryInfo = "";
    int free = 0;
    int total = 0;
    double usedPercentage = 0.0;
    if (type == "ram") {
      free = item["system"]["memory"]["ram"]["used"];
      total = item["system"]["memory"]["ram"]["total"];
      usedPercentage = item["system"]["memory"]["ram"]["%used"];
    } else if (type == "swap") {
      free = item["system"]["memory"]["swap"]["used"];
      total = item["system"]["memory"]["swap"]["total"];
      usedPercentage = item["system"]["memory"]["swap"]["%used"];
    }
    String freeString = (free / (1024 * 1024)).toStringAsFixed(1);
    String totalString = (total / (1024 * 1024)).toStringAsFixed(1);
    memoryInfo =
        "${freeString}GB / ${totalString}GB (${usedPercentage.toStringAsFixed(2)}%)";
    return memoryInfo;
  }

  handleBlockingTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int blockingTimer = prefs.getInt(KConstants.blockingTimer) ?? 0;
    int blockingTimerAddedAt =
        prefs.getInt(KConstants.blockingTimerAddedAt) ?? 0;
    // Add 1 more second to make sure it's really done with blocking
    // reducing seconds from the time since it's added so that it gives
    // updated timer when coming from other pages
    int blockingTimerValidTill =
        blockingTimerAddedAt + 1000 + (blockingTimer * 1000);
    int currentMilliSeconds = DateTime.now().millisecondsSinceEpoch;
    double differenceInSeconds =
        (blockingTimerValidTill - currentMilliSeconds) / 1000;
    log(
      "differenceInSeconds $differenceInSeconds",
      level: Level.FINE.value,
      name: "DashboardPage.handleBlockingTimer",
    );
    if (blockingTimerValidTill > currentMilliSeconds) {
      blockedTimerNotifier.value = Duration(
        seconds: differenceInSeconds.toInt(),
      );
    } else {
      log(
        "blockingTimer Invalidated",
        level: Level.FINE.value,
        name: "DashboardPage.handleBlockingTimer",
      );
      // Resetting blockingTimer as its invalidated
      await prefs.setInt(KConstants.blockingTimer, 0);
      await prefs.setInt(KConstants.blockingTimerAddedAt, 0);
    }
  }

  Future<Map<String, dynamic>> getBlockingStatus() async {
    try {
      var result = await piHttpClient.get(KUrls.dns);
      PiUtils.handleAPIException(result, false);

      isBlockedEnabledNotifier.value = (result["blocking"] == "enabled")
          ? true
          : false;
      await handleBlockingTimer();

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.getBlockingStatus",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
    }
    return {};
  }

  Future<Map<String, dynamic>> getSummary() async {
    try {
      var result = await piHttpClient.get(KUrls.summary);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.getSummary",
      );

      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSystemInfo() async {
    try {
      var result = await piHttpClient.get(KUrls.system);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.getBlockingStatus",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHostInfo() async {
    try {
      var result = await piHttpClient.get(KUrls.hosts);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.getHostInfo",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getVersion() async {
    try {
      var result = await piHttpClient.get(KUrls.versions);
      PiUtils.handleAPIException(result, false);
      log(
        result.toString(),
        level: Level.FINE.value,
        name: "DashboardPage.getVersion",
      );
      return result;
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
  }

  String getSessionExpiresIn(int sessionValidUntil) {
    // Current timestamp
    DateTime currentTimestamp = DateTime.now();

    // Old timestamp (example: 1 hour ago)
    DateTime oldTimestamp = DateTime.fromMillisecondsSinceEpoch(
      sessionValidUntil,
    );

    if (currentTimestamp.millisecondsSinceEpoch >
        oldTimestamp.millisecondsSinceEpoch) {
      return "Session Expired";
    } else {
      // Calculate the difference
      Duration difference = currentTimestamp.difference(oldTimestamp);
      int seconds = difference.inMinutes.abs() * 60;
      int differenceInSeconds = (seconds - difference.inSeconds.abs()).abs();
      return "${difference.inMinutes.abs().toString()} Mins ${differenceInSeconds.toString()} Secs";
    }
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withAlpha(90)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.3,
                child: Icon(icon, size: 80, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _versionRow({
    required String component,
    required String local,
    required String remote,
    required bool header,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                component,
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local,
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                remote,
                style: TextStyle(
                  fontWeight: header ? FontWeight.bold : FontWeight.normal,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // DNS Blocking
            FutureBuilder(
              future: getBlockingStatus(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  // var block = snapshot.data;

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      showTrailingIcon: false,
                      enabled: blockingExpansionTileEnabled,
                      childrenPadding: EdgeInsets.symmetric(
                        // horizontal: 10,
                        vertical: 5,
                      ),
                      tilePadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      expandedAlignment: Alignment.topLeft,
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      controller: blockingExpansibleController,
                      onExpansionChanged: (value) {
                        blockedExpandedStateNotifier.value = value;
                      },
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          // vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Blocking",
                                      style: TextStyle(
                                        // color: Theme.of(context).colorScheme.primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: blockedTimerNotifier,
                                      builder: (context, blockedTimer, child) {
                                        return (blockedTimer.inSeconds > 0)
                                            ? TimerCountdown(
                                                format: CountDownTimerFormat
                                                    .hoursMinutesSeconds,
                                                enableDescriptions: false,
                                                spacerWidth: 5,
                                                endTime: DateTime.now().add(
                                                  blockedTimer,
                                                ),
                                                onEnd: () {
                                                  getBlockingStatus();
                                                  blockedTimerNotifier.value =
                                                      Duration();
                                                  blockedExpandedStateNotifier
                                                          .value =
                                                      true;
                                                  blockedExpandedStateNotifier
                                                          .value =
                                                      false;
                                                },
                                              )
                                            : SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: isBlockedEnabledNotifier,
                                  builder: (context, isBlockingEnabled, child) {
                                    return Switch(
                                      value: isBlockingEnabled,
                                      onChanged: (value) =>
                                          onBlockingChanged(value, null),
                                      activeThumbColor: Colors.green,
                                      inactiveThumbColor: Colors.grey,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: blockedExpandedStateNotifier,
                                  builder:
                                      (context, blockedExpandedState, child) {
                                        return Center(
                                          child: blockedExpandedState
                                              ? Icon(Icons.keyboard_arrow_up)
                                              : Icon(Icons.keyboard_arrow_down),
                                        );
                                      },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing:
                                      8.0, // Space between columns
                                  mainAxisSpacing: 8.0, // Space between rows
                                  childAspectRatio: 1.0,
                                ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  onBlockingChanged(
                                    false,
                                    blockingTimes[index][1],
                                  );
                                  blockedExpandedStateNotifier.value = false;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[(index % 8 + 1) * 100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      blockingTimes[index][0],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Blocking",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Blocking",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),

            // SizedBox(height: 10),
            // Pi-Hole Stats Overview
            FutureBuilder(
              future: getSummary(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widge;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widge = Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var summary = snapshot.data;

                  widge = GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 1.1,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard(
                        context,
                        title: "Total Queries",
                        value: summary["queries"]["total"].toString(),
                        icon: FontAwesomeIcons.earthAmericas,
                        color: Color(0xFF00c0ef),
                      ),
                      _buildStatCard(
                        context,
                        title: "Queries Blocked",
                        value: summary["queries"]["blocked"].toString(),
                        icon: FontAwesomeIcons.hand,
                        color: Color(0xFFdd4b39),
                      ),
                      _buildStatCard(
                        context,
                        title: "Percentage Blocked",
                        value:
                            summary["queries"]["percent_blocked"]
                                .toStringAsFixed(2) +
                            "%",
                        icon: FontAwesomeIcons.chartPie,
                        color: Color(0xFFf39c12),
                      ),
                      _buildStatCard(
                        context,
                        title: "Domains on Lists",
                        value: summary["gravity"]["domains_being_blocked"]
                            .toString(),
                        icon: FontAwesomeIcons.list,
                        color: Color(0xFF00a65a),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  widge = ErrorCardWidget(
                    header: "Stats Overview",
                    message: "Error loading data",
                  );
                } else {
                  widge = EmptyCardWidget(
                    header: "Stats Overview",
                    message: "No data",
                  );
                }
                return widge;
              },
            ),
            // Pi-Hole Session Info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: KCardStyle.dashboardCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Session",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Server"),
                              Text(
                                '${auth.scheme}://${auth.server}:${auth.port}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Expires In"),
                              Text(
                                getSessionExpiresIn(auth.sessionValidUntil!),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // System and Host Information
            FutureBuilder(
              future: Future.wait([getSystemInfo(), getHostInfo()]),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var system = snapshot.data[0];
                  var host = snapshot.data[1];

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.dashboardCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "System",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Hostname"),
                                  Text(
                                    host["host"]["uname"]["nodename"]
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Product"),
                                  Text(
                                    host["host"]["dmi"]["product"]["version"]
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Uptime"),
                                  Text(
                                    PiUtils.getTimeAgo(
                                      system["system"]["uptime"],
                                      "seconds",
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ram"),
                                  Text(
                                    getMemoryInfo("ram", system),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Swap"),
                                  Text(
                                    getMemoryInfo("swap", system),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cpu"),
                                  Text(
                                    "${system["system"]["cpu"]["nprocs"]} cores (${system["system"]["cpu"]["%cpu"].toStringAsFixed(2)}%)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "System",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "System",
                    message: "No data",
                  );
                }
                return widget;
              },
            ),
            // Versions
            FutureBuilder(
              future: getVersion(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var version = snapshot.data;
                  bool isUpdateAvailable = getIsUpdateAvailable(version);

                  widget = Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: KCardStyle.dashboardCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Versions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  // color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              isUpdateAvailable
                                  ? Chip(
                                      padding: EdgeInsets.all(2),
                                      backgroundColor: Colors.green.shade300,
                                      shadowColor: Colors.green,
                                      label: Text(
                                        'Update Available',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                    )
                                  : SizedBox(width: 1),
                            ],
                          ),
                          SizedBox(height: 10),
                          _versionRow(
                            component: "Component",
                            local: "Local",
                            remote: "Remote",
                            header: true,
                          ),
                          SizedBox(height: 5),
                          _versionRow(
                            component: "core",
                            local:
                                version["version"]["core"]["local"]["version"]
                                    .toString(),
                            remote:
                                version["version"]["core"]["remote"]["version"]
                                    .toString(),
                            header: false,
                          ),
                          _versionRow(
                            component: "web",
                            local: version["version"]["web"]["local"]["version"]
                                .toString(),
                            remote:
                                version["version"]["web"]["remote"]["version"]
                                    .toString(),
                            header: false,
                          ),
                          _versionRow(
                            component: "ftl",
                            local: version["version"]["ftl"]["local"]["version"]
                                .toString(),
                            remote:
                                version["version"]["ftl"]["remote"]["version"]
                                    .toString(),
                            header: false,
                          ),
                          _versionRow(
                            component: "Docker",
                            local: version["version"]["docker"]["local"]
                                .toString(),
                            remote: version["version"]["docker"]["remote"]
                                .toString(),
                            header: false,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  widget = ErrorCardWidget(
                    header: "Versions",
                    message: "Error loading data",
                  );
                } else {
                  widget = EmptyCardWidget(
                    header: "Versions",
                    message: "No data",
                  );
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
